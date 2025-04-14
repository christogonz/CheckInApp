//
//  SessionLogCard.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-13.
//

import SwiftUI

struct SessionLogCard: View {
    let record: SessionRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(record.store.name)
                    .font(.headline)
                Spacer()
                Text(record.checkIn.formatted(date: .abbreviated, time: .omitted))
                    .font(.headline)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Check-in: \(record.checkIn.formatted(date: .omitted, time: .shortened))")
                    Text("Check-out: \(record.checkOut.formatted(date: .omitted, time: .shortened))")
                }
                .foregroundStyle(.secondary)
                Spacer()

                Text("\(formattedElapsedTime(from: record.checkIn, to: record.checkOut))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color("card"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 1)
    }

    func formattedElapsedTime(from start: Date, to end: Date) -> String {
        let interval = Int(end.timeIntervalSince(start))
        let minutes = interval / 60
        let seconds = interval % 60
        return String(format: "%02dm %02ds", minutes, seconds)
    }
}

#Preview {
    let record = SessionRecord(
        store: Store(name: "EG Barkarby", location: "Barkarby"),
        checkIn: Date().addingTimeInterval(-3000),
        checkOut: Date()
    )
    return SessionLogCard(record: record)
}
