//
//  SystemKeychainAccessProtocol.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation

@objc(SystemKeychainAccessProtocol)
protocol SystemKeychainAccessProtocol {
    func updatePassword(identifier: String, password: String, withReply: (Bool)->Void)
}
