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
            } else {
                SignInView()
            }
        }
        .environmentObject(authVM)
        
        
        
        
//        TabView {
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person")
//                }
//        }
//        .environmentObject(sessionVM)
    }
}

#Preview {
    ContentView()
}
