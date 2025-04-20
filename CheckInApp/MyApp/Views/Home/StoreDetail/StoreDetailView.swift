//
//  StoreDetailView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import SwiftUI

struct StoreDetailView: View {
    @StateObject var customSurveyVM = CustomSurveyViewModel()
    @State var responseVM = SurveyResponseViewModel()

    let store: Store
    @EnvironmentObject var sessionVM: SessionViewModel

    func formattedElapsedTime(from start: Date, to end: Date) -> String {
        let interval = Int(end.timeIntervalSince(start))
        let minutes = interval / 60
        let seconds = interval % 60
        return String(format: "%02dm %02ds", minutes, seconds)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center) {
                        // Header
                        Text(store.name)
                            .foregroundStyle(Color.text)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Location: \(store.location)")
                            .foregroundStyle(Color.secondary)
                            .padding(.bottom)

                        sessionInfoSection

                        Divider()

                        // Surveys
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Surveys")
                                .font(.title2)
                                .fontWeight(.bold)
                            ForEach(customSurveyVM.surveys) { survey in
                                NavigationLink(destination: SurveyResponseView(
                                    survey: survey,
                                    store: store,
                                    responseViewModel: responseVM)) {
                                        Text(survey.title)
                                            .foregroundStyle(Color.text)
                                            .font(.headline)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.secondary.opacity(0.12))
                                            .clipShape(.rect(cornerRadius: 10))
                                }
                            }

                            StoreSessionHistoryView(storeID: store.id ?? "")
                        }
                    }
                    .padding(.bottom, 100) // Space for button
                    .padding()
                }

                // Bottom Button
                VStack {
                    HStack {
                        if sessionVM.session?.store?.id != store.id || sessionVM.session?.checkOut != nil {
                            Button(action: {
                                sessionVM.checkIn(to: store)
                            }) {
                                Text("Check In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundStyle(Color.black)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                        } else {
                            Button(action: {
                                sessionVM.checkOut()
                            }) {
                                Text("Check Out")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundStyle(Color.white)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                }
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(store.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - Extracted View
    private var sessionInfoSection: some View {
        let isCurrentSession = sessionVM.session?.store?.id == store.id && sessionVM.session?.checkOut == nil
        let lastRecord = sessionVM.lastSession(for: store.id ?? "")

        return HStack(spacing: 16) {
            sessionDetail(title: "Check-in", value: {
                if isCurrentSession, let checkIn = sessionVM.session?.checkIn {
                    return checkIn.formatted(date: .omitted, time: .shortened)
                } else if let checkIn = lastRecord?.checkIn {
                    return checkIn.formatted(date: .omitted, time: .shortened)
                }
                return "-"
            }())

            Divider()
            sessionDetail(title: "Check-out", value: {
                if isCurrentSession {
                    return "-"
                } else if let checkOut = lastRecord?.checkOut {
                    return checkOut.formatted(date: .omitted, time: .shortened)
                }
                return "-"
            }())

            Divider()
            
            sessionDetail(title: "In-Store", value: {
                if isCurrentSession, let checkIn = sessionVM.session?.checkIn {
                    return formattedElapsedTime(from: checkIn, to: Date())
                } else if let checkIn = lastRecord?.checkIn, let checkOut = lastRecord?.checkOut {
                    return formattedElapsedTime(from: checkIn, to: checkOut)
                }
                return "-"
            }())
        }
        .frame(maxWidth: .infinity)
    }

    private func sessionDetail(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let sessionVM = SessionViewModel(userID: "preview-user")
    let storeVM = StoreViewModel()
    let store = Store(id: "store-1", name: "EG Barkarby", location: "Barkarby")

    sessionVM.history = [
        SessionRecord(
            storeID: store.id ?? "store-1",
            checkIn: Date().addingTimeInterval(-3600),
            checkOut: Date().addingTimeInterval(-1800),
            userID: "demo-user"
        )
    ]

    return StoreDetailView(store: store)
        .environmentObject(sessionVM)
        .environmentObject(storeVM)
}
