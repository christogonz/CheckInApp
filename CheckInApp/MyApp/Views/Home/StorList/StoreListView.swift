//
//  StoreListView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

struct StoreListView: View {
    @StateObject var storeVM = StoreViewModel()
    @State private var searchText = ""

        var groupedFilteredStores: [String: [Store]] {
        let filtered = storeVM.filteredStores.filter {
            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) || $0.location.lowercased().contains(searchText.lowercased())
        }
        return Dictionary(grouping: filtered) {
            $0.chain?.capitalized ?? "Other"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Título principal
                HStack {
                    Text("Search Store")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("text"))
                    Spacer()
                }
                .padding(.horizontal)

                // SearchBar
                CustomSearchBar(searchText: $searchText)

                // Lista de tiendas agrupadas
                HStack {
                    Text("Stores")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.text)
                    Spacer()
                }
                .padding(.horizontal)

                if storeVM.filteredStores.isEmpty {
                    Text("No stores found.")
                        .foregroundStyle(Color.text)
                        .padding(.horizontal)
                } else {
                    ForEach(groupedFilteredStores.keys.sorted(), id: \.self) { chain in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(chain)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)

                            ForEach(groupedFilteredStores[chain] ?? []) { store in
                                NavigationLink(destination: StoreDetailView(store: store)) {
                                    HStack {
                                        Image(store.logoImageName)
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.text, lineWidth: 0.4)
                                            )

                                        VStack(alignment: .leading) {
                                            Text(store.name)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.text)

                                            Text(store.location)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color.text)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                }
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    StoreListView()
}
