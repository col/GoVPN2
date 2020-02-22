//
//  SystemKeychainConnection.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import ApplicationServices
import os.log

class SystemKeychain: NSObject {
    
    // An XPC service
    lazy var systemKeychainConnection: NSXPCConnection = {
        let options: NSXPCConnection.Options = [NSXPCConnection.Options.privileged]
        let connection = NSXPCConnection(machServiceName: "com.colharris.GoVPNHelper", options: options)
        connection.remoteObjectInterface = NSXPCInterface(with: SystemKeychainAccessProtocol.self)
        connection.resume()
        return connection
    }()
    
    deinit {
        self.systemKeychainConnection.invalidate()
    }
    
    func updatePassword(identifier: String, password: String, withReply: (Bool)->Void) {
        os_log("Establishing connection to GoVPNHelper...", log: OSLog.app, type: .info)
        
        let connection = self.systemKeychainConnection.remoteObjectProxyWithErrorHandler { (error) in
            os_log("Remote proxy to GoVPNHelper failed. Error: %{public}@", log: OSLog.app, type: .error, error.localizedDescription)
        } as! SystemKeychainAccessProtocol
        
        os_log("Established connection to GoVPNHelper", log: OSLog.app, type: .info)
        
        connection.updatePassword(identifier: identifier, password: password) { result in
            os_log("Password updated! Result: %{public}@", log: OSLog.app, type: .info, result)
        }
        
        os_log("Request to update password sent...", log: OSLog.app, type: .info)
    }
}
