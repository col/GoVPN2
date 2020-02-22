//
//  SystemKeychainAccess.swift
//  com.colharris.GoVPNHelper
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation

class SystemKeychainAccess : NSObject, SystemKeychainAccessProtocol {
    
    func updatePassword(identifier: String, password: String, withReply: (Bool)->Void) {
        do {
            try KeychainUtils.updatePassword(label: identifier, password: password)
            withReply(true)
        } catch {
            print("Error!")
            withReply(false)
        }
    }
    
}
