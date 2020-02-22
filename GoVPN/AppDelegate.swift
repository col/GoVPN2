//
//  AppDelegate.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Cocoa
import SwiftUI
import Security
import ServiceManagement
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var authRef: AuthorizationRef?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Init the helper stuff...
        initHelper()
        
        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func initHelper() {
        os_log("init helper...", log: OSLog.app, type: .info)
        let authFlags: AuthorizationFlags = []
        let status = AuthorizationCreate(nil, nil, authFlags, &authRef)
        if status != errAuthorizationSuccess {
            os_log("Failed to create authRef for GoVPNHelper", log: OSLog.app, type: .info)
            exit(1)
        }

        if let error = getHelper() {
            os_log("Failed to install GoVPNHelper. Error: %{public}@", log: OSLog.app, type: .error, error.localizedDescription)
            exit(1)
        } else {
            os_log("GoVPNHelper installed and ready.", log: OSLog.app, type: .info)
        }
    }
    
    func getHelper() -> Error? {
        var result = false
        var error: Error?

        var authItem = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value: nil, flags: 0)
        var authRights = AuthorizationRights(count: 1, items: &authItem)
        let flags: AuthorizationFlags = [.interactionAllowed, .preAuthorize, .extendRights]

        /* Obtain the right to install our privileged helper tool (kSMRightBlessPrivilegedHelper). */
        let status = AuthorizationCopyRights(authRef!, &authRights, nil, flags, nil)
        if status != errAuthorizationSuccess {
            error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil) as Error?
        } else {
            var cfError: Unmanaged<CFError>?

            /* This does all the work of verifying the helper tool against the application
             * and vice-versa. Once verification has passed, the embedded launchd.plist
             * is extracted and placed in /Library/LaunchDaemons and then loaded. The
             * executable is placed in /Library/PrivilegedHelperTools.
             */
            result = SMJobBless(kSMDomainSystemLaunchd, "com.colharris.GoVPNHelper" as CFString, authRef, &cfError)
            if !result {
                error = cfError?.takeRetainedValue() as Error?
            }
        }

        return error
    }

}

