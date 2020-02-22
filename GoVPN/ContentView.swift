//
//  ContentView.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import SwiftUI
import os.log

struct ContentView: View {
    var body: some View {
        Button(action: {
            os_log("Updating password...", log: OSLog.app, type: .info)
            let systemKeychain = SystemKeychain()
            systemKeychain.updatePassword(identifier: "id-aegis-integration", password: "123456") { result in
                os_log("Password updated. Success = %@", log: OSLog.app, type: .info, result)
            }
        }) {
            Text("Click Me!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
