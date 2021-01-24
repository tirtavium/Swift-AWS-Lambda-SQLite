//
//  File.swift
//  
//
//  Created by Tirta Gunawan on 23/01/21.
//

import Foundation
import SotoCore

public enum SharedResource {
    static public var sqliteDBPath: String {
        get{
            #if os(Linux)
                return "/tmp/accountData.db"
            #else
                return Bundle.module.url(forResource: "accountData", withExtension: "db")?.path ?? ""
            #endif
        }
    }
    
    static public let awsClient = AWSClient(
        credentialProvider: .static(accessKeyId: "xxxx", secretAccessKey: "xxxxx"),
        httpClientProvider: .createNew)
}
