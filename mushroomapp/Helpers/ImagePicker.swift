//
//  ImagePicker.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let resized2 = image.resizedToFit(maxSize: CGSize.init(width: 512, height: 512))!
                let resize3 = resized2.resized(by: 0.7)!
                parent.image = resize3
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
    
    
}
