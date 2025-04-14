//
//  SettingNavButton.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import SwiftUI

struct SettingNavButton<Destination: View>: View {
    let icon: String
    let title: String
    let destionation: Destination
    
    var body: some View {
        NavigationLink(destination: destionation) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.accentColor)
                    .padding(.trailing, 8)
                
                Text(title)
                    .foregroundStyle(Color.text)
                    .fontWeight(.semibold)
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.text)
            }
            .padding(.horizontal)
            .padding(.top)
            
        }
    }
}

#Preview {
    SettingNavButton(icon: "person", title: "Manage all Stores", destionation: AllStoreView())
}
