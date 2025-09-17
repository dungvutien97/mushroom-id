//
//  HistoryDetailedViewModel.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import Foundation

@MainActor
final class HistoryDetailedViewModel: ObservableObject {
    @Published var mushroom: Mushroom? = nil
    @Published var isRemoved: Bool = false
    
    func connect(appState: AppState) {
        mushroom = appState.selectedMushroom
    }
 
}
