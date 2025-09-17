//
//  AppDelegate.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftUI
import Foundation
import FirebaseCore
import RevenueCat
import AppTrackingTransparency
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
                
        // RevenueCat
        Purchases.configure(withAPIKey: "appl_MSTTQjSipahCSxrBvicMtxaTFRD")
        Purchases.shared.delegate = self
        
        if ATTrackingManager.trackingAuthorizationStatus != .notDetermined {
            // The user has previously seen a tracking request, so enable automatic collection
            // before configuring in order to to collect whichever token is available
            Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        print("RC PurchasesDelegate called")
        
        // Kiểm tra trạng thái premium từ RevenueCat
        let isPremium = customerInfo.entitlements[K_RC_ENTITMENT]?.isActive == true
        
        // Lưu vào UserDefaults (sẽ đồng bộ với @AppStorage)
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
        UserDefaults.standard.synchronize()
        
        Analytics.logEvent("subscription_activated", parameters: nil)
        
        // In ra để debug
        print("RC PurchasesDelegate -> User isPremium: \(isPremium)")
    }
}
