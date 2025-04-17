//
//  MyAccountView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//

import SwiftUI
import FirebaseAuth

struct MyAccountView: View {
    var userEmail: String {
        Auth.auth().currentUser?.email ?? "No User"
    }
    
    var body: some View {
        VStack {
            Spacer()
             Text("User: \(userEmail)")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    MyAccountView()
}
