//
//  CustomButton.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

        }
    }
}

#Preview {
    CustomButton(
        title: "Check In",
        backgroundColor: .blue,
        action: {
            print("Check In tapped")
        }
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .background(Color.background)
}
