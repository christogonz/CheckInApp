//
//  StoreRow.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct StoreRow: View {
    let store: Store
    var onTap: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(store.logoImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(store.name)
                    .font(.headline)
                    .foregroundStyle(Color.text)

                Text(store.location)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onTap?()
        }
    }
}

#Preview {
    StoreRow(store: Store(name: "Elgiganten", location: "Stockholm", chain: "Elgiganten"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.background)
}
