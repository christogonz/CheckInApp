//
//  SmartListView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-01.
//

import SwiftUI

struct SmartListView: View {
    let items = ["One"]
    
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: StoreListView()) {
                            VStack {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Store List")
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(Color("AccentColor"))
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(Color("text"))
                                .padding(10)
                                Spacer()
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("5")
                                        Text("In Progress")
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(Color("text"))
                                .padding(10)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
                            .background(Color("card"))
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(radius: 1)
                        }
                        
                        NavigationLink(destination: SessionHistoryView()) {
                            VStack {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("Session logs")
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(Color("AccentColor"))
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(Color("text"))
                                .padding(10)
                                Spacer()
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("5")
                                        Text("In Progress")
                                    }
                                    Spacer()
                                }
                                .foregroundStyle(Color("text"))
                                .padding(10)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
                            .background(Color("card"))
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(radius: 1)
                        }
                    }
                }
                .padding()
            }
        
    }
}

#Preview {
    SmartListView()
}
