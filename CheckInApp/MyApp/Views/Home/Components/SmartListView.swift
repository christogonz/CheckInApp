//
//  SmartListView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-01.
//

import SwiftUI

struct SmartListView: View {
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var sessionVM: SessionViewModel

    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                // Card 1: Store List
                NavigationLink(destination: StoreListView()) {
                    cardView(
                        icon: "calendar",
                        title: "Store List",
                        value: "5",
                        subtitle: "In Progress",
                        accentIcon: "plus.circle"
                    )
                }

                // Card 2: Session Logs — ahora con los env objects
                NavigationLink(destination:
                    SessionHistoryView()
                        .environmentObject(sessionVM)
                        .environmentObject(storeVM)
                ) {
                    cardView(
                        icon: "clock",
                        title: "Session logs",
                        value: "5",
                        subtitle: "In Progress"
                    )
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    func cardView(icon: String, title: String, value: String, subtitle: String, accentIcon: String? = nil) -> some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                if let accentIcon = accentIcon {
                    Image(systemName: accentIcon)
                        .foregroundStyle(Color("AccentColor"))
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(Color("text"))
            .padding(10)

            Spacer()

            HStack {
                VStack(alignment: .leading) {
                    Text(value)
                    Text(subtitle)
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

#Preview {
    SmartListView()
        .environmentObject(StoreViewModel())
        .environmentObject(SessionViewModel())
}
