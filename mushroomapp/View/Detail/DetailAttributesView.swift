//
//  DetailAttributesView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation
import SwiftUI

struct DetailAttributesView: View {
    let attributes: MushroomAttributes

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Tên chính
            if let name = attributes.name {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            // Tên khoa học
            if let scientificName = attributes.scientificName {
                Text(scientificName)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.secondary)
            }

            Divider().padding(.vertical, 8)

            // Các thông tin chi tiết
            Group {
                detailRow(title: "Other Names:", value: attributes.otherNames)
                detailRow(title: "Family:", value: attributes.family)
                detailRow(title: "Habitat:", value: attributes.habitat)
                detailRow(title: "Season:", value: attributes.season)
                detailRow(title: "Region:", value: attributes.region)
                detailRow(title: "Cap Shape:", value: attributes.capShape)
                detailRow(title: "Cap Colour:", value: attributes.capColour)
                detailRow(title: "Cap Diameter (cm):", value: attributes.capDiameter)
                detailRow(title: "Stem Height (cm):", value: attributes.stemHeight)
                detailRow(title: "Stem Width (cm):", value: attributes.stemWidth)
                detailRow(title: "Gill Attachment:", value: attributes.gillAttachment)
                detailRow(title: "Gill Colour:", value: attributes.gillColour)
                detailRow(title: "Distinctive Features:", value: attributes.distinctiveFeatures)
                detailRow(title: "Spore Colour:", value: attributes.sporeColour)
                detailRow(title: "Spore Print Notes:", value: attributes.sporePrintNotes)
                detailRow(title: "Smell / Taste:", value: attributes.smellTaste)
                detailRow(title: "Edibility:", value: attributes.edibility)
                detailRow(title: "Toxicity Warning:", value: attributes.toxicityWarning)
            }

            if let edibilityNotes = attributes.edibilityNotes {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Edibility Notes:")
                        .font(.headline)
                    Text(edibilityNotes)
                        .font(.body)
                }
                .padding(.top, 4)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func detailRow(title: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            HStack(alignment: .top) {
                Text(title)
                    .fontWeight(.semibold)
                Text(value)
            }
        }
    }
}
