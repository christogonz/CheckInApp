//
//  ContentView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authVM = AuthViewModel()
    @StateObject var storeVM = StoreViewModel()

    var body: some View {
        Group {
            if let user = authVM.user {
                let sessionVM = SessionViewModel(userID: user.uid)

                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }

                    ProfileView()
                        .tabItem {
                            Label("Settings", systemImage: "person")
                        }
                }
                .environmentObject(authVM)
                .environmentObject(storeVM)
                .environmentObject(sessionVM)
            } else {
                SignInView()
                    .environmentObject(authVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
