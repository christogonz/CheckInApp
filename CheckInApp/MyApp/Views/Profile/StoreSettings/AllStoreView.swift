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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("All Stores")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showingAddModal = true
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)

            if storeVM.userStores.isEmpty {
                Text("No stores yet")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(storeVM.allStores) { store in
                            StoreRow(store: store) {
                                selectedStore = store
                                showingEditModal = true
                            }
                        }
                        .sheet(isPresented: $showingEditModal) {
                            if let store = selectedStore {
                                EditStoreModal(isPresented: $showingEditModal, store: store)
                                    .environmentObject(storeVM)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showingAddModal) {
            AddStoreModal(isPresented: $showingAddModal)
                .environmentObject(storeVM)
        }
        .padding(.top)
        .background(Color.background)
    }
}


#Preview {
    AllStoreView()
}
