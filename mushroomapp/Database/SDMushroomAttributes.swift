//
//  SDMushroomAttributes.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation
import SwiftData

@Model
final class SDMushroomAttributes: Identifiable {
    @Attribute var id: UUID

    @Attribute var name: String?
    @Attribute var otherNames: String?
    @Attribute var family: String?
    @Attribute var scientificName: String?
    @Attribute var habitat: String?
    @Attribute var season: String?
    @Attribute var region: String?
    @Attribute var capShape: String?
    @Attribute var capColour: String?
    @Attribute var capDiameter: String?
    @Attribute var stemHeight: String?
    @Attribute var stemWidth: String?
    @Attribute var gillAttachment: String?
    @Attribute var gillColour: String?
    @Attribute var distinctiveFeatures: String?
    @Attribute var sporeColour: String?
    @Attribute var sporePrintNotes: String?
    @Attribute var smellTaste: String?
    @Attribute var edibility: String?
    @Attribute var toxicityWarning: String?
    @Attribute var edibilityNotes: String?

    init(id: UUID, name: String? = nil, otherNames: String? = nil, family: String? = nil, scientificName: String? = nil, habitat: String? = nil, season: String? = nil, region: String? = nil, capShape: String? = nil, capColour: String? = nil, capDiameter: String? = nil, stemHeight: String? = nil, stemWidth: String? = nil, gillAttachment: String? = nil, gillColour: String? = nil, distinctiveFeatures: String? = nil, sporeColour: String? = nil, sporePrintNotes: String? = nil, smellTaste: String? = nil, edibility: String? = nil, toxicityWarning: String? = nil, edibilityNotes: String? = nil) {
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
}

extension SDMushroomAttributes {
    func asDomain() -> MushroomAttributes {
        return MushroomAttributes(id: self.id,
                                  name: self.name,
                                  otherNames: self.otherNames,
                                  family: self.family,
                                  scientificName: self.scientificName,
                                  habitat: self.habitat,
                                  season: self.season,
                                  region: self.region,
                                  capShape: self.capShape,
                                  capColour: self.capColour,
                                  capDiameter: self.capDiameter,
                                  stemHeight: self.stemHeight,
                                  stemWidth: self.stemWidth,
                                  gillAttachment: self.gillAttachment,
                                  gillColour: self.gillColour,
                                  distinctiveFeatures: self.distinctiveFeatures,
                                  sporeColour: self.sporeColour,
                                  sporePrintNotes: self.sporePrintNotes,
                                  smellTaste: self.smellTaste,
                                  edibility: self.edibility,
                                  toxicityWarning: self.toxicityWarning,
                                  edibilityNotes: self.edibilityNotes)
    }
}
