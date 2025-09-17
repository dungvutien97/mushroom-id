//
//  HomeViewModel.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 11/9/25.
//

import CoreLocation
import Foundation
import UIKit

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isCameraPresented = false
    @Published var isAskedLocationPermission: Bool = false

    // Tạo ảnh demo
    func sampleImageData(named name: String) -> Data {
        UIImage(named: name)?.jpegData(compressionQuality: 0.8) ?? Data()
    }

    // Dữ liệu mẫu
    @Published var sampleMushrooms: [Mushroom] = [
        Mushroom(
            lat: 21.0278,
            long: 105.8342,
            createdAt: Date()
        ),
        Mushroom(
            lat: 21.0280,
            long: 105.8350,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        ),
        Mushroom(
            lat: 21.0265,
            long: 105.8330,
            createdAt: Date()
        ),
        Mushroom(
            lat: 21.0250,
            long: 105.8320,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        )
    ]
}
