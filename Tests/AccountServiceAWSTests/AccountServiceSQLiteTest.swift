//
//  File.swift
//  
//
//  Created by Tirta Gunawan on 24/01/21.
//

import Foundation
import XCTest
@testable import AccountServiceAWS
/*
Currently SPM unable to have unit test on executable project
move it to Library type if you like to have unit test
https://bugs.swift.org/browse/SR-9359
*/
final class AccountServiceSQLiteTest: XCTestCase {
    
    var service = AccountServiceSQLite()
    
    func testGetAccounts_Success(){
        XCTAssertNotNil(service.getAccounts())
    }
    
    func testFindAccount_Success(){
        XCTAssertNotNil(service.findAccount(id: 1))
    }
}
