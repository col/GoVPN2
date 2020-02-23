//
//  MenuController.swift
//  GoVPN
//
//  Created by Colin Harris on 23/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Cocoa
import os.log
import SwiftOTP

class MenuController: NSObject {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var preferencesWindow: NSWindowController?
    
    override init() {
        super.init()
        setStatusItemImage()
        statusItem.menu = constructMenu()
    }
    
    func setStatusItemImage() {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
    }
    
    func constructMenu() -> NSMenu {
        let vpns = VPNConfiguration.shared.vpns().filter { $0.enabled }
        
        let menu = NSMenu()
        menu.delegate = self
        
        let vpnGroups = Dictionary(grouping: vpns, by: { $0.group })
        let groupNames = vpnGroups.keys.sorted(by: { $0 ?? "" < $1 ?? "" })
        
        if vpns.count > 0 {
            var count = 0
            for groupName in groupNames {
                let groupVpns = vpnGroups[groupName]!
                var indent = 0
                if let name = groupName {
                    indent = 1
                    menu.addItem(NSMenuItem(title: name, action: nil, keyEquivalent: ""))
                }
                
                for vpn in groupVpns.sorted(by: { $0.name < $1.name }) {
                    count += 1
                    menu.addItem(menuItem(for: vpn, number: count, indent: indent))
                }
                menu.addItem(NSMenuItem.separator())
            }
        } else {
            menu.addItem(NSMenuItem(title: "Invalid config", action: nil, keyEquivalent: ""))
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem(title: "Preferences...", action: #selector(showPreferences(_:)), keyEquivalent: ","))
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit GoVPN", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
                
        return menu
    }
 
    func menuItem(title: String, action: Selector?, keyEquivalent: String) -> NSMenuItem {
        let item = NSMenuItem()
        item.title = title
        item.target = self
        item.action = action
        item.keyEquivalent = keyEquivalent
        return item
    }

    func menuItem(for vpn: VPN, number: Int, indent: Int = 0) -> NSMenuItem {
        let item = menuItem(title: vpn.name, action: #selector(selectVPN(_:)), keyEquivalent: "\(number)")
        item.indentationLevel = indent
        item.representedObject = vpn
        return item
    }
    
    @objc func selectVPN(_ sender: Any?) {
        if let menuItem = sender as? NSMenuItem, let vpn = menuItem.representedObject as? VPN {
            vpn.toggleStatus()
        }
    }
    
    @objc func showPreferences(_ sender: Any?) {
        os_log("showPreferences", log: OSLog.app, type: .info)
        if preferencesWindow == nil {
            preferencesWindow = NSStoryboard.init(name: NSStoryboard.Name("Preferences"), bundle: nil).instantiateInitialController()
        }
       
        if let windowController = preferencesWindow {
            windowController.showWindow(sender)
            // Ensure the window becomes active and appears in front
            NSApp.activate(ignoringOtherApps: true)
            windowController.window?.makeKeyAndOrderFront(self)
        }
   }
    
}

extension MenuController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menuWillOpen")
        for menuItem in statusItem.menu?.items ?? [] {
            if let vpn = menuItem.representedObject as? VPN {
                if let vpnService = VPNServicesManager.shared.service(named: vpn.name),
                    vpnService.state() == .connected || vpnService.state() == .connecting
                {
                    menuItem.state = .on
                } else {
                    menuItem.state = .off
                }
            }
        }
    }
        
}
