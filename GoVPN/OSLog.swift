//
//  OSLog.swift
//  GoVPN
//
//  Created by Colin Harris on 22/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let app = OSLog(subsystem: subsystem, category: "app")
}
