//
//  mushroomappApp.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 23/8/25.
//

import SwiftData
import SwiftUI

@main
struct mushroomappApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var locationManager = LocationManager()
    
    // DI
    @Inject private var signInAnonymouslyUseCase: SignInAnonymouslyUseCase
    
    var body: some Scene {
        WindowGroup {
//            HomeView()
            OnboardingView()
                .colorScheme(.light)
                .environmentObject(homeRouter)
                .environmentObject(appState)
                .environmentObject(locationManager)
                .modelContainer(for: [SDMushroom.self, SDMushroomAttributes.self])
                .task {
                    try? await signInAnonymouslyUseCase.execute()
                }
        }
    }
}
