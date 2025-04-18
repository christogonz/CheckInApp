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
        VStack {
            Text(store.name)
                .foregroundStyle(Color.text)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Location: \(store.location)")
                .foregroundStyle(Color.secondary)

            
            let isCurrentStoreSession = sessionVM.session?.store?.id == store.id && sessionVM.session?.checkOut == nil
            let lastRecord = sessionVM.lastSession(for: store.id ?? "")

            HStack {
                Spacer()

                VStack {
                    Text("Check-in")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)
                    if isCurrentStoreSession, let checkIn = sessionVM.session?.checkIn {
                        Text(checkIn.formatted(date: .omitted, time: .shortened))
                    } else if let checkIn = lastRecord?.checkIn {
                        Text(checkIn.formatted(date: .omitted, time: .shortened))
                    } else {
                        Text("-")
                    }
                    Spacer()
                }
                .frame(width: 100)

                Spacer()
                Divider()
                Spacer()

                VStack {
                    Text("Check-out")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)

                    if isCurrentStoreSession {
                        Text("-")
                    } else if let checkOut = lastRecord?.checkOut {
                        Text(checkOut.formatted(date: .omitted, time: .shortened))
                    } else {
                        Text("-")
                    }

                    Spacer()
                }
                .frame(width: 100)

                Spacer()
                Divider()
                Spacer()

                VStack {
                    Text("In-Store")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)

                    if isCurrentStoreSession, let checkIn = sessionVM.session?.checkIn {
                        if sessionVM.session?.checkOut == nil {
                            Text(formattedElapsedTime(from: checkIn, to: Date()))
                        } else if let checkOut = sessionVM.session?.checkOut {
                            Text(formattedElapsedTime(from: checkIn, to: checkOut))
                        }
                    } else if let checkIn = lastRecord?.checkIn, let checkOut = lastRecord?.checkOut {
                        Text(formattedElapsedTime(from: checkIn, to: checkOut))
                    } else {
                        Text("-")
                    }

                    Spacer()
                }
                .frame(width: 100)

                Spacer()
            }
            .frame(height: 50)

            Divider()

            // Surveys
            Text("Surveys")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(customSurveyVM.surveys) { survey in
                        NavigationLink(
                            destination: SurveyResponseView(
                                survey: survey,
                                store: store,
                                responseViewModel: responseVM
                            )
                        ) {
                            Text(survey.title)
                                .foregroundStyle(Color.text)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.secondary.opacity(0.12))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }

                    // MARK: Session Logs Section
                    StoreSessionHistoryView(storeID: store.id ?? "")
                        .padding(.top)
                }
            }
            .padding(.top, 8)

            Spacer()

            
            if sessionVM.session?.store?.id != store.id || sessionVM.session?.checkOut != nil {
                CustomButton(
                    title: "Check In",
                    backgroundColor: Color.accentColor,
                    textColor: Color.black,
                    action: {
                        sessionVM.checkIn(to: store)
                    }
                )
            } else {
                CustomButton(
                    title: "Check Out",
                    backgroundColor: Color.red,
                    textColor: Color.white, 
                    action: {
                        sessionVM.checkOut()
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
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
