//
//  CameraSheetModifier.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 12/9/25.
//

import Foundation
import SwiftUI

struct CameraSheetModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                CameraView()
            }
    }
}

extension View {
    func sheetCameraView(isPresented: Binding<Bool>) -> some View {
        self.modifier(CameraSheetModifier(isPresented: isPresented))
    }
}
