//
//  StoreListView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

// MARK: - StoreListView.swift
struct StoreListView: View {
    @StateObject var storeVM = StoreViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            //Tittle
            HStack {
                Text("Search Store")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("text"))
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            
            //SearchBar
            CustomSearchBar(searchText: $searchText)
            
            //StoreList
            ScrollView(showsIndicators: false) {
                //Title
                HStack {
                    Text("Stores")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.text)
                        .padding(.top)
                    Spacer()
                }
                .padding(.horizontal)
                
                //List
                if storeVM.filteredStores.isEmpty {
                    Text("No stores found.").foregroundColor(Color.text)
                } else {
                    ForEach(storeVM.filteredStores.filter {
                        searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) || $0.location.lowercased().contains(searchText.lowercased())
                    }) { store in
                        
                        NavigationLink(destination: StoreDetailView(store: store)) {
                            
                            
                            HStack {
                                Image("eg_logo")
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
                                    .foregroundColor(Color.text)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    StoreListView()
}
