//
//  Mushroom.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 9/9/25.
//

import CoreLocation
import Foundation

final class Mushroom: Identifiable {
    var id: UUID

    // Location
    var lat: Double?
    var long: Double?

    var imageData: Data?

    var createdAt: Date

    var attributes: MushroomAttributes?

    // Computed properties
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat!, longitude: long!)
    }

    init(id: UUID = UUID(),
         lat: Double?,
         long: Double?,
         imageData: Data? = nil,
         attributes: MushroomAttributes? = nil,
         createdAt: Date = Date())
    {
        self.id = id
        self.lat = lat
        self.long = long
        self.imageData = imageData
        self.attributes = attributes
        self.createdAt = createdAt
    }
}

extension Mushroom {
    static let sample = Mushroom(
        lat: 48.8566,
        long: 2.3522,
        attributes: .sample
    )

    static let samples: [Mushroom] = [
        Mushroom(
            lat: 48.8566, long: 2.3522,
            attributes: .sample
        ),
        Mushroom(
            lat: 52.5200, long: 13.4050,
            attributes: MushroomAttributes(
                name: "Chanterelle",
                otherNames: "Girolle",
                family: "Cantharellaceae",
                scientificName: "Cantharellus cibarius",
                habitat: "Woodlands, mossy forest floors",
                season: "Summer to autumn",
                region: "Europe, North America",
                capShape: "Trumpet-shaped",
                capColour: "Golden yellow",
                capDiameter: "3–10 cm",
                stemHeight: "3–8 cm",
                stemWidth: "1–2 cm",
                gillAttachment: "Decurrent (runs down the stem)",
                gillColour: "Yellow",
                distinctiveFeatures: "Pleasant fruity smell, wavy cap edges",
                sporeColour: "Yellow to white",
                smellTaste: "Fruity, apricot-like aroma",
                edibility: "Edible",
                edibilityNotes: "Highly prized edible mushroom"
            )
        )
    ]
}
