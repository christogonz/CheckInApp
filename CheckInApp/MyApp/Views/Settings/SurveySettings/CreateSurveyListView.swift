//
//  CreateSurveyListView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//





import SwiftUI

struct CreateSurveyListView: View {
    @StateObject private var viewModel = CustomSurveyViewModel()
    @State private var showingAddSurvey = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                        
                //MARK: Survey List
                if viewModel.surveys.isEmpty {
                    Text("No surveys created yet")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            // Title
                            Text("Surveys")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            
                            //List
                            ForEach(viewModel.surveys, id: \.safeID) { survey in
                                NavigationLink(destination: EditSurveyFormView(survey: survey, viewModel: viewModel)) {
                                    
                                    // list Items
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(survey.title)
                                            .font(.headline)
                                            .foregroundStyle(Color.primary)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.secondary.opacity(0.10))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                }
                            }
                        }
                        .padding()
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        showingAddSurvey = true
                    }) {
                        Image(systemName: "plus")
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddSurvey) {
                AddSurveyFormView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    CreateSurveyListView()
}





//ScrollView(showsIndicators: false) {
//    VStack(alignment: .leading, spacing: 12) {
//        Text("Surveys")
//            .font(.largeTitle)
//            .fontWeight(.bold)
//            .foregroundStyle(.secondary)
//        
//    if viewModel.surveys.isEmpty {
//        Text("No surveys created yet")
//            .foregroundColor(.gray)
//            .padding(.horizontal)
//    } else {
//
//                ForEach(viewModel.surveys, id: \.safeID) { survey in
//                    NavigationLink(destination: EditSurveyFormView(survey: survey, viewModel: viewModel)) {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(survey.title)
//                                .font(.headline)
//                                .foregroundStyle(Color.primary)
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.secondary.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                }
//            }
//    }
//    .padding()
//}
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.sheet(isPresented: $showingAddSurvey) {
//    AddSurveyFormView(viewModel: viewModel)
//}
//.padding(.top)
//.background(Color.background)
