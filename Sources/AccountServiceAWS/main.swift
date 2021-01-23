import AWSLambdaRuntime
import Foundation
import CSQLite3

struct Input: Codable {
    let id: Int
}

struct Output: Codable {
    let account: Account?
    let message: String
}

let accountService:AccountService = AccountServiceSQLite()

Lambda.run { (context, input: Input, callback: @escaping (Result<Output, Error>) -> Void) in
    
    let accounts = accountService.getAccounts()
    print(accounts)
    if let account = accountService.findAccount(id: input.id){
        callback(.success(Output(account: account, message: "success")))
    }else{
        callback(.success(Output(account: nil, message: "Account not found")))
    }
    
    
}

