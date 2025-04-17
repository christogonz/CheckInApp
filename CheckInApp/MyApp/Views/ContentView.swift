//
//  ContentView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sessionVM = SessionViewModel()
    @StateObject var authVM = AuthViewModel()
    @StateObject var storeVM = StoreViewModel()

    var body: some View {
        Group {
            if authVM.user != nil {
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
                .environmentObject(sessionVM)
                .environmentObject(storeVM) // ✅ Añadir StoreViewModel
            } else {
                SignInView()
            }
        }
        .environmentObject(authVM)
    }
}

#Preview {
    ContentView()
}
