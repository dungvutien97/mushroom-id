//
//  AppState.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import SwiftUI
import UIKit
import Foundation

class AppState: ObservableObject {
    @Published var capturedImage: UIImage? = UIImage(named: "mushroom_example")
    
    @Published var selectedMushroom: Mushroom?
    
}
