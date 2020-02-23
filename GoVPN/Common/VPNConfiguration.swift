//
//  VPNParser.swift
//  GoVPN
//
//  Created by Colin Harris on 23/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation

class VPNConfiguration {
        
    static let shared = VPNConfiguration()
    
    let userDefaults = UserDefaults.standard
    
    func vpns() -> [VPN] {
        var vpns: [VPN] = []
        for vpnService in VPNServicesManager.shared.services {
            vpns.append(loadVpnConfig(named: vpnService.name()))
        }
        return vpns
    }
    
    func loadVpnConfig(named name: String) -> VPN {
        if let vpnData = userDefaults.value(forKey: name) as? Data {
            return try! JSONDecoder().decode(VPN.self, from: vpnData)
        } else {
            return VPN(name: name, enabled: false, group: nil)
        }
    }
    
    func saveVpns(vpns: [VPN]) {
        for vpn in vpns {
            let encodedData = try! JSONEncoder().encode(vpn)
            userDefaults.set(encodedData, forKey: vpn.name)
        }
    }

}
