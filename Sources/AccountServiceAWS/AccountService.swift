//
//  File.swift
//  
//
//  Created by Tirta Gunawan on 23/01/21.
//

import Foundation
import CSQLite3
import SotoS3

protocol AccountService {
    func getAccounts() -> [Account]
    func findAccount(id: Int) -> Account?
}
class AccountServiceSQLite: AccountService {
    var db: OpaquePointer?
    var isDBOpen = false
    
    func getAccounts() -> [Account] {
        
        var accounts:[Account] = []
        if !isDBOpen{
            openDB()
        }
        let querySql = "SELECT * FROM Accounts"
        
        guard let queryStatement = prepareStatement(sql: querySql) else {
            return []
        }
        
        //traversing through all the records
        while(sqlite3_step(queryStatement) == SQLITE_ROW){
            let account = queryStatement.toAccount()
            accounts.append(account)
        }
        
        return accounts
    }
    
    func findAccount(id: Int) -> Account?{
        
        if !isDBOpen{
            openDB()
        }
        
        let querySql = "SELECT * FROM Accounts where ID = ?"
        
        guard let queryStatement = prepareStatement(sql: querySql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(id)) == SQLITE_OK else {
            return nil
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
        
        return queryStatement.toAccount()
        
    }
    
    fileprivate func openDB() {
        
        downloadSQLiteDBFromS3()
    
        if sqlite3_open(SharedResource.sqliteDBPath, &db) != SQLITE_OK {
            print("error opening database")
            isDBOpen = false
        }else{
            isDBOpen = true
        }
    }
    
    private func prepareStatement(sql: String) -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil)
                == SQLITE_OK else {
            print("error prepare")
            return nil
        }
        return statement
    }
    
    
    fileprivate func downloadSQLiteDBFromS3() {
        var body: Data?
        let fm = FileManager.default
        
        if !fm.fileExists(atPath: SharedResource.sqliteDBPath) {
            
            let s3 = S3(client: SharedResource.awsClient, region: .apsoutheast1)
            let getObjectRequest = S3.GetObjectRequest(bucket: "calculationservice", key: "accountData.db")
            do {
                let response = try s3.getObject(getObjectRequest).wait()
                body = response.body?.asData()
            }catch{
                print("error s3.getObject \(error.localizedDescription)")
            }
            if body != nil {
                do {
                    try body!.write(to: URL(fileURLWithPath: SharedResource.sqliteDBPath))
                }catch{
                    print("error saving tmp \(error.localizedDescription)")
                }
            }
        }else{
            print("\(SharedResource.sqliteDBPath) is there")
        }
    }
    
}


extension OpaquePointer{
    func toAccount()-> Account{
        let id = sqlite3_column_int(self, 0)
        let name = String(cString: sqlite3_column_text(self, 1))
        let dateOfBirth =  String(cString: sqlite3_column_text(self, 2))
        let email =  String(cString: sqlite3_column_text(self, 3))
        return Account(ID: Int(id), Name: name, dateOfBirth: dateOfBirth, email: email)
    }
}
