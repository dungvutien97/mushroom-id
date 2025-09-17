//
//  VDWebView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import Foundation
import SwiftUI
import WebKit

struct VDWebView: UIViewRepresentable {
    let urlString: String

     func makeUIView(context: Context) -> WKWebView {
         return WKWebView()
     }

     func updateUIView(_ uiView: WKWebView, context: Context) {
         if let url = URL(string: urlString) {
             let request = URLRequest(url: url)
             uiView.load(request)
         }
     }
}
