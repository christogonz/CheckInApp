//
//  HeaderView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-01.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("TestPlan")
                .font(.title)
                .foregroundStyle(Color.accentColor)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "antenna.radiowaves.left.and.right")
            }
            .foregroundStyle(Color("text"))
            .fontWeight(.bold)
        }
        .padding()
        .background(Color("background"))
    }
}

#Preview {
    HeaderView()
}
