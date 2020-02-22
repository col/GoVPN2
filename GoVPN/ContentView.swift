//
//  ContentView.swift
//  GoVPN
//
//  Created by Colin Harris on 21/2/20.
//  Copyright © 2020 Colin Harris. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        Button(action: {
            
            let systemKeychain = SystemKeychain()
            systemKeychain.updatePassword(identifier: "id-aegis-integration", password: "123456") { result in
                print("Update password. Success = \(result)")
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
