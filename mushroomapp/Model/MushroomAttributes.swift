//
//  MushroomAttributes.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation

final class MushroomAttributes: Identifiable, Codable {
    var id: UUID = .init()

    var name: String?
    var otherNames: String?
    var family: String?
    var scientificName: String?
    var habitat: String?
    var season: String?
    var region: String?
    var capShape: String?
    var capColour: String?
    var capDiameter: String?
    var stemHeight: String?
    var stemWidth: String?
    var gillAttachment: String?
    var gillColour: String?
    var distinctiveFeatures: String?
    var sporeColour: String?
    var sporePrintNotes: String?
    var smellTaste: String?
    var edibility: String?
    var toxicityWarning: String?
    var edibilityNotes: String?

    init(
        id: UUID = UUID(),
        name: String? = nil,
        otherNames: String? = nil,
        family: String? = nil,
        scientificName: String? = nil,
        habitat: String? = nil,
        season: String? = nil,
        region: String? = nil,
        capShape: String? = nil,
        capColour: String? = nil,
        capDiameter: String? = nil,
        stemHeight: String? = nil,
        stemWidth: String? = nil,
        gillAttachment: String? = nil,
        gillColour: String? = nil,
        distinctiveFeatures: String? = nil,
        sporeColour: String? = nil,
        sporePrintNotes: String? = nil,
        smellTaste: String? = nil,
        edibility: String? = nil,
        toxicityWarning: String? = nil,
        edibilityNotes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.otherNames = otherNames
        self.family = family
        self.scientificName = scientificName
        self.habitat = habitat
        self.season = season
        self.region = region
        self.capShape = capShape
        self.capColour = capColour
        self.capDiameter = capDiameter
        self.stemHeight = stemHeight
        self.stemWidth = stemWidth
        self.gillAttachment = gillAttachment
        self.gillColour = gillColour
        self.distinctiveFeatures = distinctiveFeatures
        self.sporeColour = sporeColour
        self.sporePrintNotes = sporePrintNotes
        self.smellTaste = smellTaste
        self.edibility = edibility
        self.toxicityWarning = toxicityWarning
        self.edibilityNotes = edibilityNotes
    }

    enum CodingKeys: String, CodingKey {
        case name, otherNames, family, scientificName, habitat, season, region
        case capShape, capColour, capDiameter
        case stemHeight, stemWidth
        case gillAttachment, gillColour
        case distinctiveFeatures
        case sporeColour, sporePrintNotes
        case smellTaste
        case edibility, toxicityWarning, edibilityNotes
    }

    // ✅ Custom decoder để tránh crash khi thiếu key
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.otherNames = try container.decodeIfPresent(String.self, forKey: .otherNames)
        self.family = try container.decodeIfPresent(String.self, forKey: .family)
        self.scientificName = try container.decodeIfPresent(String.self, forKey: .scientificName)
        self.habitat = try container.decodeIfPresent(String.self, forKey: .habitat)
        self.season = try container.decodeIfPresent(String.self, forKey: .season)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.capShape = try container.decodeIfPresent(String.self, forKey: .capShape)
        self.capColour = try container.decodeIfPresent(String.self, forKey: .capColour)
        self.capDiameter = try container.decodeIfPresent(String.self, forKey: .capDiameter)
        self.stemHeight = try container.decodeIfPresent(String.self, forKey: .stemHeight)
        self.stemWidth = try container.decodeIfPresent(String.self, forKey: .stemWidth)
        self.gillAttachment = try container.decodeIfPresent(String.self, forKey: .gillAttachment)
        self.gillColour = try container.decodeIfPresent(String.self, forKey: .gillColour)
        self.distinctiveFeatures = try container.decodeIfPresent(String.self, forKey: .distinctiveFeatures)
        self.sporeColour = try container.decodeIfPresent(String.self, forKey: .sporeColour)
        self.sporePrintNotes = try container.decodeIfPresent(String.self, forKey: .sporePrintNotes)
        self.smellTaste = try container.decodeIfPresent(String.self, forKey: .smellTaste)
        self.edibility = try container.decodeIfPresent(String.self, forKey: .edibility)
        self.toxicityWarning = try container.decodeIfPresent(String.self, forKey: .toxicityWarning)
        self.edibilityNotes = try container.decodeIfPresent(String.self, forKey: .edibilityNotes)
    }
}

extension MushroomAttributes {
    static let sample = MushroomAttributes(
        name: "Fly Agaric",
        otherNames: "Amanita muscaria",
        family: "Amanitaceae",
        scientificName: "Amanita muscaria",
        habitat: "Coniferous and deciduous forests",
        season: "Late summer to autumn",
        region: "Northern Hemisphere",
        capShape: "Convex to flat",
        capColour: "Bright red with white spots",
        capDiameter: "8–20 cm",
        stemHeight: "5–20 cm",
        stemWidth: "1–3 cm",
        gillAttachment: "Free",
        gillColour: "White",
        distinctiveFeatures: "White spots on red cap, bulbous base",
        sporeColour: "White",
        sporePrintNotes: "Produces white spore print",
        smellTaste: "Slightly sweet, unpleasant taste",
        edibility: "Poisonous",
        toxicityWarning: "Can cause hallucinations and severe poisoning",
        edibilityNotes: "Not edible, toxic when ingested"
    )
}
