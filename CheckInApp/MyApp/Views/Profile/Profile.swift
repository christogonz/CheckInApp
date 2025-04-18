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
    @ObservedObject var profileVM: UserProfileViewModel

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
                    HStack(spacing: 10) {
                        if let image = profileVM.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        } else {
                            Image(systemName: "person.circle")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.accentColor)
                                .padding(.trailing, 10)
                        }


                        VStack(alignment: .leading) {
                            Text(profileVM.firstName)
                                .foregroundStyle(Color.text)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text(profileVM.lastName)
                                .foregroundStyle(Color.secondary)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
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

                    SettingNavButton(icon: "person", title: "My Account", destionation: MyAccountView())
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
        .onAppear {
            profileVM.loadUserData()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var mockProfileVM = UserProfileViewModel()

        var body: some View {
            ProfileView(profileVM: mockProfileVM)
                .environmentObject(AuthViewModel())
                .onAppear {
                    mockProfileVM.firstName = "Christopher"
                    mockProfileVM.lastName = "Gonzalez"
                    mockProfileVM.image = UIImage(systemName: "person.crop.circle.fill")
                }
        }
    }

    return PreviewWrapper()
}
