//
//  File.swift
//  
//
//  Created by Tirta Gunawan on 23/01/21.
//

import Foundation
import CSQLite3
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
        if sqlite3_open(SharedResource.sqliteDBURL?.path, &db) != SQLITE_OK {
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
