//
//  ProfileEditModalView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-18.
//
import SwiftUI

struct ProfileEditModalView: View {
    @ObservedObject var profileVM: UserProfileViewModel
    @Binding var isPresented: Bool
    @FocusState private var isEditing: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Info")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                TextField("Name", text: $profileVM.firstName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                TextField("Last name", text: $profileVM.lastName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: {
                profileVM.updateUserProfile()
                isPresented = false
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            Spacer()
        }
        .presentationBackground(.ultraThinMaterial)
        .padding()
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var isPresented = true
        @StateObject private var mockVM = UserProfileViewModel()

        var body: some View {
            ProfileEditModalView(profileVM: mockVM, isPresented: $isPresented)
                .onAppear {
                    mockVM.firstName = "Christopher"
                    mockVM.lastName = "Gonzalez"
                }
        }
    }

    return PreviewWrapper()
}
