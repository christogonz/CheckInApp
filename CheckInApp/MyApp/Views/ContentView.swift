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
            if authVM.isCheckingSession {
                // ⏳ Pantalla de carga
                VStack {
                    Spacer()
                    ProgressView("Loading your account...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .transition(.opacity)
            } else if let user = authVM.user {
                let sessionVM = SessionViewModel(userID: user.uid)
                let profileVM = UserProfileViewModel()

                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }

                    SttingsView(profileVM: profileVM)
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
