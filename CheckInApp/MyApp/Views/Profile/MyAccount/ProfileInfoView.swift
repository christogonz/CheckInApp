//
//  ProfileInfoView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-18.
//

import SwiftUI
import FirebaseAuth

struct ProfileInfoView: View {
    @ObservedObject var profileVM: UserProfileViewModel

    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Text(profileVM.firstName)
                            .font(.body)
                    }
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Last name")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Text(profileVM.lastName)
                            .font(.body)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Text(Auth.auth().currentUser?.email ?? "No Email")
                            .font(.body)
                    }
                }
            }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var mockVM = UserProfileViewModel()

        var body: some View {
            ProfileInfoView(profileVM: mockVM)
                .padding()
                .background(Color.background)
                .onAppear {
                    mockVM.firstName = "Chris"
                    mockVM.lastName = "Gonzalez"
                }
        }
    }

    return PreviewWrapper()
}
