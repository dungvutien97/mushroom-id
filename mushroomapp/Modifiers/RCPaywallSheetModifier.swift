//
//  RCPaywallSheetModifier.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import RevenueCat
import RevenueCatUI
import Foundation
import SwiftUI

struct RCPaywallSheetModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, content: {
                RevenueCatUI.PaywallView(displayCloseButton: true)
            })
    }
}

extension View {
    func presentRCPaywallSheet(isPresented: Binding<Bool>) -> some View {
        self.modifier(RCPaywallSheetModifier(isPresented: isPresented))
    }
}
