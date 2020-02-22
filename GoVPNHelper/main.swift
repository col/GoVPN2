//
//  main.swift
//  GoVPNHelper
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import os.log

print("GoVPNHelper starting...")
os_log("GoVPNHelper starting...", log: OSLog.helper, type: .info)

class ServiceDelegate : NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        os_log("ServiceDelegate.shouldAcceptNewConnection..", log: OSLog.helper, type: .info)
        newConnection.exportedInterface = NSXPCInterface(with: SystemKeychainAccessProtocol.self)
        let exportedObject = SystemKeychainAccess()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        os_log("New connection resumed.", log: OSLog.helper, type: .info)
        return true
    }
}

// Create the listener and resume it:
let delegate = ServiceDelegate()
//let listener = NSXPCListener.service()
let listener = NSXPCListener.init(machServiceName: "com.colharris.GoVPNHelper")
listener.delegate = delegate;
listener.resume()
os_log("GoVPNHelper started", log: OSLog.helper, type: .info)

RunLoop.current.run()

//do {
//    try KeychainUtils.updatePassword(label: "id-aegis-integration", password: "running-xcode")
//    print("success!")
//} catch {
//    print("Error!")
//}

