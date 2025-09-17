//
//  ImagePickerSheetModifier.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI

struct ImagePickerSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ImagePicker(sourceType: sourceType, image: $image)
                    .ignoresSafeArea()
            }
    }
}

extension View {
    func presentImagePickerSheet(
        isPresented: Binding<Bool>,
        image: Binding<UIImage?>,
        sourceType: UIImagePickerController.SourceType = .photoLibrary
    ) -> some View {
        self.modifier(ImagePickerSheetModifier(
            isPresented: isPresented,
            image: image,
            sourceType: sourceType
        ))
    }
}
