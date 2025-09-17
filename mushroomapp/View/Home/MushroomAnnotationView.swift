//
//  MushroomAnnotationView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import MapKit
import SwiftUI

struct MushroomAnnotationView: View {
    let mushroom: SDMushroom
    @State private var rotationAngle: Double = 0
    @State private var shakeCount = 0

    var body: some View {
        VStack(spacing: 0) {
            // Circle chứa ảnh
            if let imageData = mushroom.imageData,
               let uiimage = UIImage(data: imageData)
            {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 2)
            }

            // Tam giác pin
            Triangle()
                .fill(Color.white)
                .frame(width: 16, height: 10)
                .shadow(radius: 1)
                .offset(y: -2)
        }
        .alignmentGuide(.bottom) { d in d[.bottom] }
        .overlay(
            Text(mushroom.attributes?.name ?? "??")
                .font(.caption2)
                .padding(4)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(6)
                .offset(y: 40),
            alignment: .bottom
        )
        // Lắc quanh mũi tam giác
        .rotationEffect(
            .degrees(rotationAngle),
            anchor: .bottom
        )
        .onAppear {
            shakePin()
        }
    }

    private func shakePin() {
        // lắc ±10 độ, 3 lần
        let angles: [Double] = [10, -10, 10, -10, 0]
        for (index, angle) in angles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                withAnimation(.easeInOut(duration: 0.15).delay(1)) {
                    rotationAngle = angle
                }
            }
        }
    }
}

// Tam giác
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // mũi nhọn ở giữa cạnh dưới
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
