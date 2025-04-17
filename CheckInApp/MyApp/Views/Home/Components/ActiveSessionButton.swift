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
        if let session = sessionVM.session,
           let store = session.store,
           session.checkIn != nil,
           session.checkOut == nil {

            NavigationLink(destination: StoreDetailView(store: store)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Session: \(store.name)")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("⏱ \(formattedElapsedTime(from: sessionVM.elapsedTime))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
        }
    }
}
