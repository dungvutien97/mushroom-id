//
//  MapDisplayType.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import MapKit
import SwiftUI

enum MapDisplayType: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case satellite = "Satellite"
    case hybrid = "Hybrid"

    var id: String { self.rawValue }

    var mapStyle: MapStyle {
        switch self {
        case .standard: return .standard
        case .satellite: return .imagery
        case .hybrid: return .hybrid
        }
    }
}
