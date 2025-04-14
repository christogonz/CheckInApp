//
//  CustomSearchBar.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-01.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .padding(.leading)
            
            TextField("Search...", text: $searchText)
        }
        .padding(10)
        .background(Color.card)
        .clipShape(.rect(cornerRadius: 10))
        .foregroundStyle(Color.text)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.5)
        )
        .padding(.horizontal)
        
    }
}

#Preview {
    CustomSearchBar(searchText: .constant(""))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        
}
