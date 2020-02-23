//
//  OTP.swift
//  GoVPN
//
//  Created by Colin Harris on 23/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import SwiftOTP
import os.log

class OTP {
    
    static func getOtp() -> String? {
        do {
            let token = try KeychainUtils.queryPassword(label: "com.colharris.GoVPN.token")
            if let data = base32DecodeToData(token),
                let totp = TOTP(secret: data),
                let otp = totp.generate(time: Date()) {
                return otp
            }
        } catch {
            os_log("Error retrieving OTP token. Error: %{public}@", log: .app, type: .error, error.localizedDescription)
        }
        return nil
    }
}
