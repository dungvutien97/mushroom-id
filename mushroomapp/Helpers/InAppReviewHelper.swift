//
//  InAppReviewHelper.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftUI
import StoreKit

extension View {
    /// Hiển thị view và tự động hiện popup đánh giá in-app
    func onAppearInAppRating() -> some View {
        self.onAppear {
            requestInAppRatingIfNeeded()
        }
    }
    
    private func requestInAppRatingIfNeeded() {
        // Kiểm tra lần trước đã hỏi chưa (ví dụ 30 ngày)
        let lastAsked = UserDefaults.standard.object(forKey: "lastAskedInAppRating") as? Date
        guard lastAsked == nil || Date().timeIntervalSince(lastAsked!) > 30*24*60*60 else { return }
        
        // Lấy window scene hiện tại
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            // Lưu lại thời điểm đã hỏi
            UserDefaults.standard.set(Date(), forKey: "lastAskedInAppRating")
        }
    }
}
