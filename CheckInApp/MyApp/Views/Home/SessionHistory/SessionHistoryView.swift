//
//  SessionHistoryView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-13.
//

import SwiftUI

struct SessionHistoryView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @EnvironmentObject var storeVM: StoreViewModel

    @State private var showDatePicker = false
    @State private var selectedDate: Date? = nil

    var filteredHistory: [SessionRecord] {
        guard let selected = selectedDate else { return sessionVM.history }
        let calendar = Calendar.current
        return sessionVM.history.filter {
            calendar.isDate($0.checkIn, inSameDayAs: selected)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Session logs")
                    .foregroundStyle(Color.text)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()
                Button(action: {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }) {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .padding(8)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }

                if selectedDate != nil {
                    Button("Clear") {
                        selectedDate = nil
                    }
                    .font(.caption)
                }
            }
            .padding(.horizontal)

            if showDatePicker {
                DatePicker("Filtrar por fecha", selection: Binding(get: {
                    selectedDate ?? Date()
                }, set: { newValue in
                    selectedDate = newValue
                }), displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(
                        Dictionary(grouping: filteredHistory) { record in
                            Calendar.current.startOfDay(for: record.checkIn)
                        }
                        .sorted(by: { $0.key > $1.key }),
                        id: \.key
                    ) { date, records in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                                .padding(.top, 8)
                                .padding(.leading)

                            ForEach(records.sorted { $0.checkIn > $1.checkIn }) { record in
                                SessionLogCard(record: record)
                                    .environmentObject(storeVM)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.background)
    }
}

#Preview {
    let sessionVM = SessionViewModel(userID: "preview-user")
    let storeVM = StoreViewModel()

    sessionVM.history = [
        SessionRecord(
            storeID: "store-1",
            checkIn: Date().addingTimeInterval(-4000),
            checkOut: Date().addingTimeInterval(-2000),
            userID: "user1"
        ),
        SessionRecord(
            storeID: "store-2",
            checkIn: Date().addingTimeInterval(-90000),
            checkOut: Date().addingTimeInterval(-88000),
            userID: "user1"
        )
    ]

    return SessionHistoryView()
    
    
        .environmentObject(sessionVM)
        .environmentObject(storeVM)
}
