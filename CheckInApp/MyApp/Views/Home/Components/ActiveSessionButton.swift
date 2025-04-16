//
//  ActiveSessionButton.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct ActiveSessionButton: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    
    func formattedElapsedTime(from interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02dm %02ds", minutes, seconds)
    }
    
    var body: some View {
        if let store = sessionVM.session.store,
           sessionVM.session.checkOut == nil {
            
            NavigationLink(destination: StoreDetailView(store: store)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Session: \(store.name)")
                        .font(.headline)
                    Text("⏱ \(formattedElapsedTime(from: sessionVM.elapsedTime))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor)
                .foregroundStyle(Color.text)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    let sessionVM = SessionViewModel()
    sessionVM.checkIn(to: Store(id: UUID(), name: "EG Barkarby", location: "Barkarby"))
    return ActiveSessionButton()
        .environmentObject(sessionVM)
}
