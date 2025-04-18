//
//  MyAccountView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct MyAccountView: View {
    @ObservedObject var profileVM: UserProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isShowingEditModal = false
    @FocusState private var isEditing: Bool

    init(profileVM: UserProfileViewModel = UserProfileViewModel()) {
        _profileVM = ObservedObject(wrappedValue: profileVM)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                ProfileImageView(profileVM: profileVM, selectedItem: $selectedItem)

                Divider()
                    .padding(.top)

                ProfileInfoView(profileVM: profileVM)
                
                Divider()

                Spacer()
            }
            .padding()
            .onAppear {
                profileVM.loadUserData()
            }
            .background(Color.background)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingEditModal = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(Color.text)
                    }
                }
            }
            .sheet(isPresented: $isShowingEditModal) {
                ProfileEditModalView(profileVM: profileVM, isPresented: $isShowingEditModal)
            }
        }
    }
}

#Preview {
    let mockVM = UserProfileViewModel()
    mockVM.firstName = "Christopher"
    mockVM.lastName = "Gonzalez"
    mockVM.image = UIImage(systemName: "person.crop.circle.fill")
    

    return MyAccountView(profileVM: mockVM)
}
