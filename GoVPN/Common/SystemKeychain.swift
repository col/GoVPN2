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
    
    static let shared = SystemKeychain()
    
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
    
    func updatePassword(identifier: String, service: String, password: String, withReply: @escaping (Bool)->Void) {
        os_log("Establishing connection to GoVPNHelper...", log: OSLog.app, type: .info)
        
        let connection = self.systemKeychainConnection.remoteObjectProxyWithErrorHandler { (error) in
            os_log("Remote proxy to GoVPNHelper failed. Error: %{public}@", log: OSLog.app, type: .error, error.localizedDescription)
            withReply(false)
        } as! SystemKeychainAccessProtocol
        
        os_log("Established connection to GoVPNHelper", log: OSLog.app, type: .info)
        
        connection.updatePassword(identifier: identifier, service: service, password: password) { result in
            os_log("Password updated!", log: OSLog.app, type: .info)
            withReply(result)
        }
        
        os_log("Request to update password sent...", log: OSLog.app, type: .info)
    }
}
