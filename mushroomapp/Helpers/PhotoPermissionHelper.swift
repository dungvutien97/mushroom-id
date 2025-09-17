//
//  PhotoPermissionHelper.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import Photos
import UIKit

class PhotoPermissionHelper: NSObject {
    static func checkPhotoLibraryPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized
        default:
            return false
        }
    }
    
    static func topMostViewController() -> UIViewController? {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else {
            return nil
        }

        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }

        return topVC
    }

    static func alertGoSettings() {
        guard let topVC = topMostViewController() else {
            print("No visible controller found")
            return
        }

        let alert = UIAlertController(
            title: "Permission Required",
            message: "Please allow photo library access in Settings to continue.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))

        DispatchQueue.main.async {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
