//
//  SupaResponse.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import Foundation

struct SupaResponse: Identifiable, Codable {
    var id: UUID = UUID()
    let success: Bool
    let analysis: MushroomAttributes

    enum CodingKeys: String, CodingKey {
        case success
        case analysis
    }
}
