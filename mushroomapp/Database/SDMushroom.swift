//
//  SDMushroom.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class SDMushroom: Identifiable {
    @Attribute var id: UUID

    @Attribute var lat: Double?
    @Attribute var long: Double?

    @Attribute(.externalStorage)
    var imageData: Data?

    @Attribute var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var attributes: SDMushroomAttributes?

    init(id: UUID = UUID(),
         lat: Double?,
         long: Double?,
         attributes: SDMushroomAttributes? = nil,
         createdAt: Date = Date())
    {
        self.id = id
        self.lat = lat
        self.long = long
        self.attributes = attributes
        self.createdAt = createdAt
    }

    // Computed properties
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)
    }
    
}

extension SDMushroom {
    func asDomain() -> Mushroom {
        return Mushroom(id: self.id,
                        lat: self.lat,
                        long: self.long,
                        imageData: self.imageData,
                        attributes: self.attributes?.asDomain(),
                        createdAt: self.createdAt)
    }
}
