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
    
    func updatePassword(identifier: String, password: String, withReply: (Bool)->Void) {
        os_log("SystemKeychainAccess.updatePassword...", log: OSLog.helper, type: .info)
        do {
            try KeychainUtils.updatePassword(label: identifier, password: password)
            os_log("SystemKeychainAccess.updatePassword. Success!", log: OSLog.helper, type: .info)
            withReply(true)
        } catch {
            os_log("SystemKeychainAccess.updatePassword. Error: %{public}@", log: OSLog.helper, type: .info, error.localizedDescription)
            withReply(false)
        }
    }
    
}
