//
//  SystemKeychainAccess.swift
//  com.colharris.GoVPNHelper
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import os.log

class SystemKeychainAccess : NSObject, SystemKeychainAccessProtocol {
    
    func updatePassword(identifier: String, service: String, password: String, withReply: (Bool)->Void) {
        
        do {

            os_log("SystemKeychainAccess.itemExists with label %{public}@ and service %{public}@", log: OSLog.helper, type: .info, identifier, service)
            if KeychainUtils.itemExists(withLabel: identifier, andService: service) {
                os_log("SystemKeychainAccess.updatePassword...", log: OSLog.helper, type: .info)
                try KeychainUtils.updatePassword(label: identifier, service: service, password: password)
            } else {
                os_log("SystemKeychainAccess.createPassword...", log: OSLog.helper, type: .info)
                let item = try KeychainUtils.addPassword(label: identifier, service: service, password: password)
                os_log("SystemKeychainAccess.created: %{public}@", log: OSLog.helper, type: .info, item!)
            }
            
            os_log("SystemKeychainAccess. Success!", log: OSLog.helper, type: .info)
            withReply(true)
        } catch {
            os_log("SystemKeychainAccess. Error: %{public}@", log: OSLog.helper, type: .info, error.localizedDescription)
            withReply(false)
        }
    }
    
}
