//
//  AllStoreView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//


import SwiftUI

struct AllStoreView: View {
    @StateObject private var storeVM = StoreViewModel()
    @State private var showingAddModal = false

    @State private var selectedStore: Store?
    @State private var showingEditModal = false

    var groupedStores: [String: [Store]] {
        Dictionary(grouping: storeVM.repository.stores) {
            $0.chain?.capitalized ?? "Other"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                if storeVM.repository.stores.isEmpty {
                    Text("No stores yet")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("All Stores")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            ForEach(groupedStores.keys.sorted(), id: \.self) { chain in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(chain)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)

                                    ForEach(groupedStores[chain] ?? []) { store in
                                        StoreRow(store: store) {
                                            selectedStore = store
                                            showingEditModal = true
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddModal = true
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    } label: {
                        Image(systemName: "plus")
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundStyle(.black)
                            .clipShape(Circle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddModal) {
                AddStoreModal(isPresented: $showingAddModal)
                    .environmentObject(storeVM)
            }
            .sheet(isPresented: $showingEditModal) {
                if let store = selectedStore {
                    EditStoreModal(isPresented: $showingEditModal, store: store)
                        .environmentObject(storeVM)
                }
            }
        }
    }
}

#Preview {
    AllStoreView()
}
