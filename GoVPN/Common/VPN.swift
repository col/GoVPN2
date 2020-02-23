
//
//  VPN.swift
//  GoVPN
//
//  Created by Colin Harris on 7/1/19.
//  Copyright © 2019 Colin Harris. All rights reserved.
//

import Foundation
import os.log


@objc
class VPN: NSObject, Codable {
    @objc var name: String
    @objc var enabled: Bool
    @objc var group: String?
    
    init(name: String, enabled: Bool, group: String? = nil) {
        self.name = name
        self.enabled = enabled
        self.group = group
    }
    
    func toggleStatus() {
        if let vpnService = VPNServicesManager.shared.service(named: name) {
            if vpnService.state() == .connected || vpnService.state() == .connecting {
                vpnService.disconnect()
            } else {
                guard let otp = OTP.getOtp() else {
                    os_log("Failed to generate OTP for %{public}@...", log: OSLog.app, type: .error, name)
                    return
                }
                                
                SystemKeychain.shared.updatePassword(identifier: name, password: otp) { result in
                    os_log("Connecting to VPN with new password... ", log: OSLog.app, type: .info)
                    vpnService.connect()
                    os_log("Connected.", log: OSLog.app, type: .info)
                }
            }
        }
    }
}
