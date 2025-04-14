//
//  Profile.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

// MARK: - ProfileView.swift
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
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
                
                Divider()
                    .padding(.horizontal)
                
                HStack {
                    Text("Account")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .padding(.horizontal)
                    Spacer()
                }
                
                
                SettingNavButton(
                    icon: "person",
                    title: "My Profile",
                    destionation: AllStoreView()
                )
                
                SettingNavButton(
                    icon: "storefront",
                    title: "Store Settings",
                    destionation: AllStoreView()
                )
                
                SettingNavButton(
                    icon: "questionmark.text.page",
                    title: "Survey Settings",
                    destionation: CreateSurveyListView()
                )
                
                Divider()
                    .padding(.horizontal)
                    .padding(.top)
                
                SettingNavButton(
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "Logout",
                    destionation: CreateSurveyListView()
                )

                Spacer()
                

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    ProfileView()
}

