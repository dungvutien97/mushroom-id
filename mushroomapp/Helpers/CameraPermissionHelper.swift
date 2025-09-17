//
//  CameraPermissionHelper.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import AVFoundation
import UIKit

class CameraPermissionHelper: NSObject {
    static func checkCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default:
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
            title: "Camera Permission Required",
            message: "Please allow camera access in Settings to continue.",
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
