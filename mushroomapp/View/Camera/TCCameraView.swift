//
//  TCCameraView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI

struct TCCameraView: UIViewControllerRepresentable {
    var onCapture: (UIImage) -> Void

    class Coordinator: NSObject, TCCameraDelegate {
        var parent: TCCameraView

        init(_ parent: TCCameraView) {
            self.parent = parent
        }

        func cameraDidCapturePhoto(_ image: UIImage) {
            parent.onCapture(image)
        }

        func cameraDidFail(with error: Error) {
            print("Camera error: \(error.localizedDescription)")
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> TCCamera {
        let cameraVC = TCCamera()
        cameraVC.delegate = context.coordinator
        return cameraVC
    }

    func updateUIViewController(_ uiViewController: TCCamera, context: Context) {}
}
