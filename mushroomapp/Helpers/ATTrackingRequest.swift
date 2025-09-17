//
//  ATTrackingRequest.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import AppTrackingTransparency
import RevenueCat
import SwiftUI

extension View {
    /// Hiển thị view và tự động request App Tracking khi cần
    func onAppearRequestTracking() -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { _ in
                        Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
                    }
                }
            }
        }
    }
}
