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

    var survey: Survey {
        sessionVM.surveys[store.id.uuidString] ?? Survey(question1: false, question2: false, question3: false)
    }

    func formattedElapsedTime(from interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02dm %02ds", minutes, seconds)
    }

    var body: some View {
        VStack {
            Text("\(store.name)")
                .foregroundStyle(Color.text)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Location: \(store.location)")
                .foregroundStyle(Color.secondary)

            HStack {
                Spacer()

                // Check-In Text
                VStack {
                    Text("Check-in")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)
                    if let checkIn = sessionVM.session.checkIn, sessionVM.session.store == store {
                        Text(checkIn.formatted(date: .omitted, time: .shortened))
                    }
                    Spacer()
                }
                .frame(width: 100)

                Spacer()
                Divider().foregroundStyle(Color.text)
                Spacer()

                // Check-Out Text
                VStack {
                    Text("Check-out")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)
                    if let checkOut = sessionVM.session.checkOut, sessionVM.session.store == store {
                        Text(checkOut.formatted(date: .omitted, time: .shortened))
                    }
                    Spacer()
                }
                .frame(width: 100)

                Spacer()
                Divider().foregroundStyle(Color.secondary)
                Spacer()

                // Total Time
                VStack {
                    Text("In-Store")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)

                    if let checkIn = sessionVM.session.checkIn, sessionVM.session.store == store {
                        if sessionVM.session.checkOut == nil {
                            // Tiempo en vivo desde el ViewModel
                            Text(formattedElapsedTime(from: sessionVM.elapsedTime))
                        } else if let checkOut = sessionVM.session.checkOut {
                            // Tiempo fijo
                            let total = checkOut.timeIntervalSince(checkIn)
                            Text(formattedElapsedTime(from: total))
                        }
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

            //MARK: Survey List
            Text("Surveys")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
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
                }
            }
            .padding(.top, 8)

            Spacer()

            // Check-in Button
                if sessionVM.session.store != store || sessionVM.session.checkOut != nil {
                    
                    
                    CustomButton(
                        title: "Check In",
                        backgroundColor: Color.accentColor,
                        action: {
                            sessionVM.checkIn(to: store)
                        }
                  )

                } else {
                    
                    CustomButton(
                        title: "Check Out",
                        backgroundColor: Color.red,
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
    let sessionVM = SessionViewModel()
        let testStore = Store(id: UUID(), name: "EG Barkarby", location: "Barkarby")
        sessionVM.checkIn(to: testStore)

        return StoreDetailView(store: testStore)
            .environmentObject(sessionVM)
}

