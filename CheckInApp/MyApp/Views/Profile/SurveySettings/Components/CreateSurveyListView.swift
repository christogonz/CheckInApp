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
        VStack(alignment: .leading) {
            HStack {
                Text("Surveys")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showingAddSurvey = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(8)
                        .background(Color.accentColor)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)

            if viewModel.surveys.isEmpty {
                Text("No surveys created yet")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.surveys, id: \.safeID) { survey in
                            NavigationLink(destination: EditSurveyFormView(survey: survey, viewModel: viewModel)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(survey.title)
                                        .font(.headline)
                                        .foregroundStyle(Color.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingAddSurvey) {
            AddSurveyFormView(viewModel: viewModel)
        }
        .padding(.top)
        .background(Color.background)
    }
}

#Preview {
    CreateSurveyListView()
}
