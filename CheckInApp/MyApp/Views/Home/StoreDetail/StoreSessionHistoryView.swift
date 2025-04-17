//
//  StoreSessionHistoryView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-17.
//

import SwiftUI

struct StoreSessionHistoryView: View {
    let storeID: String
    @EnvironmentObject var sessionVM: SessionViewModel
    
    var storeSessions: [SessionRecord] {
        sessionVM.history.filter { $0.storeID == storeID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session History")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            if storeSessions.isEmpty {
                Text("No previous sessions")
                    .foregroundStyle(.gray)
            } else {
                ForEach(storeSessions.sorted { $0.checkIn > $1.checkIn }) { record in
                    SessionLogCard(record: record)
                }
            }
        }
    }
}


#Preview {
    let sessionVM = SessionViewModel(userID: "preview-user")
    let storeID = "store-1"

 
    sessionVM.history = [
        SessionRecord(
            storeID: storeID,
            checkIn: Date().addingTimeInterval(-7200),
            checkOut: Date().addingTimeInterval(-3600),
            userID: "test-user"
        ),
        SessionRecord(
            storeID: storeID,
            checkIn: Date().addingTimeInterval(-10800),
            checkOut: Date().addingTimeInterval(-9000),
            userID: "test-user"
        )
    ]

    return StoreSessionHistoryView(storeID: storeID)
        .environmentObject(sessionVM)
}
