//
//  Profile.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var animateSignOut = false

    var body: some View {
        NavigationStack {
            if animateSignOut {
                VStack {
                    Spacer()
                    ProgressView("Signing out...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .font(.headline)
                        .scaleEffect(animateSignOut ? 1.2 : 0.8)
                        .opacity(animateSignOut ? 1 : 0)
                        .animation(.easeInOut(duration: 0.4), value: animateSignOut)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .transition(.opacity)
            } else {
                ScrollView {
                    // MARK: Header
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.accentColor)
                            .padding(.trailing, 10)

                        Text("Chris Gonzalez")
                            .foregroundStyle(Color.text)
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()

                    Divider().padding(.horizontal)

                    // MARK: Account Section
                    HStack {
                        Text("Account")
                            .fontWeight(.semibold)
                            .font(.title2)
                            .padding(.horizontal)
                        Spacer()
                    }

                    SettingNavButton(icon: "person", title: "My Profile", destionation: AllStoreView())
                    SettingNavButton(icon: "storefront", title: "Store Settings", destionation: AllStoreView())
                    SettingNavButton(icon: "questionmark.text.page", title: "Survey Settings", destionation: CreateSurveyListView())

                    Divider()
                        .padding(.horizontal)
                        .padding(.top)

                    // MARK: SignOut Button
                    Button {
                        withAnimation {
                            animateSignOut = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            authVM.signOut()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.accentColor)
                                .padding(.trailing, 8)

                            Text("Sign Out")
                                .foregroundStyle(Color.text)
                                .fontWeight(.semibold)
                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.text)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}


