//
//  ProfileImageView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-18.
//

import SwiftUI
import PhotosUI

struct ProfileImageView: View {
    @ObservedObject var profileVM: UserProfileViewModel
    @Binding var selectedItem: PhotosPickerItem?
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 12) {
            
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                if let image = profileVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.background)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())

            VStack {
                Text(profileVM.firstName)
                    .font(.title)
                    .foregroundStyle(Color.text)
                
                Text(profileVM.lastName)
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 160)
        .onChange(of: selectedItem) {
            guard let item = selectedItem else { return }
            Task {
                do {
                    if let data = try await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileVM.uploadProfileImage(uiImage)
                    }
                } catch {
                    print("❌ Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedItem: PhotosPickerItem? = nil
        @StateObject private var mockVM = UserProfileViewModel()

        var body: some View {
            ProfileImageView(profileVM: mockVM, selectedItem: $selectedItem)
                .padding()
                .background(Color.background)
                .onAppear {
                    mockVM.firstName = "Christopher"
                    mockVM.lastName = "Gonzalez"
                    mockVM.image = UIImage(systemName: "person.crop.circle.fill")
                }
        }
    }

    return PreviewWrapper()
}
