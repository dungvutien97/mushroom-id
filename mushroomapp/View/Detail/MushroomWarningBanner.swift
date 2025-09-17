//
//  MushroomWarningBanner.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 17/9/25.
//

import SwiftUI

struct MushroomWarningBanner: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Safety Disclaimer")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("This app is for educational purposes only. Do NOT use it to decide whether a mushroom is safe to eat or handle. Always consult a qualified expert before consuming wild mushrooms.")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.red.opacity(0.08))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.6), lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    MushroomWarningBanner()
}
