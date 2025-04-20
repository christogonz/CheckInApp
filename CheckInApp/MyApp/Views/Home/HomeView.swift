//
//  HomeView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

// MARK: - HomeView.swift
struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                SmartListView()

                Spacer()

                ActiveSessionButton()
            }
            .background(Color("background"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("WorkPlan")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                    }
                    .foregroundStyle(Color("text"))
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    let sessionVM = SessionViewModel(userID: "preview-user")
    let storeVM = StoreViewModel()

    sessionVM.checkIn(to: Store(name: "EG Barkarby", location: "Barkarby"))

    return HomeView()
        .environmentObject(sessionVM)
        .environmentObject(storeVM)
}
