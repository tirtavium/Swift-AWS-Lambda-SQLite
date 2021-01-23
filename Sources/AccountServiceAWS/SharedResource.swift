//
//  File.swift
//  
//
//  Created by Tirta Gunawan on 23/01/21.
//

import Foundation


public enum SharedResource {
    static public let sqliteDBURL = Bundle.module.url(forResource: "accountData", withExtension: "db")
}
