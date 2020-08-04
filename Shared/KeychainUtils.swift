//
//  KeychainUtils.swift
//  com.colharris.GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import Foundation
import Security
import os.log

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

typealias KeychainQuery = CFDictionary

class KeychainUtils {

    static func queryPassword(label: String) throws -> String {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query(forLabel: label), &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        return password
    }

    static func updatePassword(label: String, service: String, password: String) throws {
        let passwordData = password.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecValueData as String: passwordData]
        
        let status = SecItemUpdate(query(forLabel: label, andService: service), attributes as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    // Using SecItemAdd
    static func addPassword(label: String, service: String, password: String) throws -> [String: Any]? {
        var access: SecAccess?
        let accessStatus = SecAccessCreate("All" as CFString, nil, &access)
        guard accessStatus == errSecSuccess else { throw KeychainError.unhandledError(status: accessStatus)}
        guard access != nil else { throw KeychainError.unhandledError(status: 666) }
        
        var acl: SecACL?
        let promptSelector: SecKeychainPromptSelector = []
        let aclStatus = SecACLCreateWithSimpleContents(access!, nil, "All" as CFString, promptSelector, &acl)
        guard accessStatus == errSecSuccess else { throw KeychainError.unhandledError(status: aclStatus) }
        
        let passwordData = password.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label,
            kSecAttrService as String: service,
            kSecAttrAccess as String: access!,
            kSecAttrDescription as String: "IPSec XAuth Password",
            kSecAttrAccount as String: "colin.harris",
            kSecAttrComment as String: "Created by GoVPN",
            kSecValueData as String: passwordData
        ]
                
        var item: CFTypeRef?
        let status = SecItemAdd(attributes as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        let updateStatus = SecItemUpdate(query(forLabel: label, andService: service), attributes as CFDictionary)
        guard updateStatus == errSecSuccess else { throw KeychainError.unhandledError(status: updateStatus) }
        
        return item as? [String: Any]
    }
    
    static func itemExists(withLabel label: String, andService service: String) -> Bool {
        do {
            let item = try findItem(with: query(forLabel: label, andService: service))
            return item != nil
        } catch {
            return false
        }
    }
        
    static func findItem(with query: KeychainQuery) throws -> CFTypeRef? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }        
        return item
        
        // Consider switching to: SecKeychainFindGenericPassword
    }
    
    static func query(forLabel label: String) -> KeychainQuery {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ] as CFDictionary
    }
    
    static func query(forLabel label: String, andService service: String) -> KeychainQuery {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ] as CFDictionary
    }
}
