//
//  HomeRouterKey.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation
import SwiftUI

// Khai báo Router
enum HomeRoute: Hashable {
    case detail
    case history
    case settings
}

final class HomeRouter: ObservableObject {
    @Published var path: [HomeRoute] = []
    
    func push(_ route: HomeRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
