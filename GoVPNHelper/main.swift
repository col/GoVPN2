//
//  main.swift
//  GoVPNHelper
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation

class ServiceDelegate : NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: SystemKeychainAccessProtocol.self)
        let exportedObject = SystemKeychainAccess()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}


// Create the listener and resume it:
//
let delegate = ServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate;
listener.resume()


//do {
//    try KeychainUtils.updatePassword(label: "id-aegis-integration-test", password: "testing")
//    print("success!")
//} catch {
//    print("Error!")
//}

