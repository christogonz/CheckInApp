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
            VStack {
                HeaderView()

                SmartListView()

                Spacer()

                ActiveSessionButton()
            }
            .background(Color("background"))
        }
    }
}

#Preview {
    let sessionVM = SessionViewModel()
    let storeVM = StoreViewModel()

    // Simular una sesión activa para previsualización
    sessionVM.checkIn(to: Store(name: "EG Barkarby", location: "Barkarby"))

    return HomeView()
        .environmentObject(sessionVM)
        .environmentObject(storeVM)
}
