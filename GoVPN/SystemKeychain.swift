//
//  SystemKeychainConnection.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import ApplicationServices

class SystemKeychain: NSObject {
    
    // An XPC service
    lazy var systemKeychainConnection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: "com.colharris.GoVPNHelper")
        connection.remoteObjectInterface = NSXPCInterface(with: SystemKeychainAccessProtocol.self)
        connection.resume()
        return connection
    }()
    
    deinit {
        self.systemKeychainConnection.invalidate()
    }
    
    func updatePassword(identifier: String, password: String, withReply: (Bool)->Void) {        
        let connection = self.systemKeychainConnection.remoteObjectProxyWithErrorHandler { (error) in
            print("remote proxy error: %@", error)
        } as! SystemKeychainAccessProtocol
        
        connection.updatePassword(identifier: identifier, password: password) { result in
            print("Password updated!")
        }
    }
}
