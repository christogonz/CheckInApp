//
//  AddStoreModal.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct AddStoreModal: View {
    @EnvironmentObject var storeVM: StoreViewModel
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var location = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Store")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                TextField("Store Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                TextField("Location", text: $location)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {
                guard !name.isEmpty && !location.isEmpty else { return }
                storeVM.userStores.append(Store(name: name, location: location))
                isPresented = false
            }) {
                Text("Add Store")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(name.isEmpty || location.isEmpty)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    AddStoreModal(isPresented: .constant(true))
        .environmentObject(StoreViewModel())
}
