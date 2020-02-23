//
//  MenuController.swift
//  GoVPN
//
//  Created by Colin Harris on 23/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Cocoa
import os.log

class MenuController: NSObject {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
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
        let menu = NSMenu()
        menu.delegate = self
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(MenuController.showPreferences(_:)), keyEquivalent: ","))
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit GoVPN", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
                
        return menu
    }
 
    @objc func showPreferences(_ sender: Any?) {
        os_log("showPreferences", log: OSLog.app, type: .info)
    }
    
}

extension MenuController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menuWillOpen")
    }
        
}
