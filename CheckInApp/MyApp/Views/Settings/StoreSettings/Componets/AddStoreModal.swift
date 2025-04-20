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
    @State private var selectedChain: String?

    let chains = [
        ("Elgiganten", "eg_logo"),
        ("PhoneHouse", "eph_logo"),
        ("Telia", "telia_logo"),
        ("Tele2", "tele2_logo"),
        ("Telenor", "telenor_logo"),
        ("Tre", "tre_logo")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Text("Add New Store")
                    .font(.title2)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Store name")
                        .foregroundStyle(Color.text)
                    TextField("ELG Barkarby...", text: $name)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Store location")
                        .foregroundStyle(Color.text)
                    TextField("Barkarby...", text: $location)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Store Chain")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(chains, id: \.0) { chainName, imageName in
                                VStack(spacing: 8) {
                                    Button(action: {
                                        selectedChain = chainName
                                    }) {
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedChain == chainName ? Color.accentColor : .clear, lineWidth: 3)
                                            )
                                            .shadow(radius: selectedChain == chainName ? 5 : 0)
                                    }

                                    Text(chainName)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(selectedChain == chainName ? Color.accentColor : Color.secondary)
                                }
                                .frame(width: 70)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                    }
                }

                Button(action: {
                    guard !name.isEmpty && !location.isEmpty else { return }
                    let newStore = Store(name: name, location: location, chain: selectedChain)
                    storeVM.repository.addStore(newStore)
                    isPresented = false
                }) {
                    Text("Add Store")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(name.isEmpty || location.isEmpty)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(.thinMaterial)
    }
}

#Preview {
    AddStoreModal(isPresented: .constant(true))
        .environmentObject(StoreViewModel())
}
