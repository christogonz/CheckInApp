//
//  EditStoreModal.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct EditStoreModal: View {
    @EnvironmentObject var storeVM: StoreViewModel
    @Binding var isPresented: Bool
    let store: Store

    @State private var name: String
    @State private var location: String

    init(isPresented: Binding<Bool>, store: Store) {
        self._isPresented = isPresented
        self.store = store
        _name = State(initialValue: store.name)
        _location = State(initialValue: store.location)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Store")
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

            HStack(spacing: 15) {
                CustomButton(
                    title: "Delete",
                    backgroundColor: .red,
                    textColor: .white,
                    action: {
                        storeVM.repository.deleteStore(store)
                        isPresented = false
                    }
                )

                CustomButton(
                    title: "Save",
                    backgroundColor: Color.accentColor,
                    textColor: .black,
                    action: {
                        storeVM.repository.updateStoreFields(
                            storeId: store.id ?? "",
                            name: name,
                            location: location
                        )
                        isPresented = false
                    }
                )
            }

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    EditStoreModal(isPresented: .constant(true), store: Store(id: "preview", name: "Elgiganten", location: "Stockholm"))
        .environmentObject(StoreViewModel())
}
