//
//  PreferencesViewController.swift
//  GoVPN
//
//  Created by Colin Harris on 5/1/19.
//  Copyright © 2019 Colin Harris. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet var versionLabel: NSTextField!
    @IBOutlet var availableVPNsAC: NSArrayController!
        
    override func viewDidAppear() {
        super.viewDidAppear()
        
        versionLabel.stringValue = "v\(appVersion()) (\(buildNumber()))"
        
        availableVPNsAC.content = nil
        for vpn in VPNConfiguration.shared.vpns() {
            availableVPNsAC.addObject(vpn)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.window?.windowController?.close()
    }
    
    @IBAction func save(_ sender: Any) {
        VPNConfiguration.shared.saveVpns(vpns: availableVPNsAC!.arrangedObjects as! [VPN])
        self.view.window?.windowController?.close()
    }
    
    private func appVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.0"
    }
    
    private func buildNumber() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"
    }
}
