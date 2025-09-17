//
//  HomeView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 11/9/25.
//

import CoreLocation
import MapKit
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = .init()
    @EnvironmentObject var router: HomeRouter
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationManager: LocationManager

    @AppStorage("isPremium") private var isPremium: Bool = false
    @State private var isPaywallPresented: Bool = false

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                MushroomMapView()
                HomeControlView()
            } //: ZSTACK
            .environmentObject(viewModel)
            .sheetCameraView(isPresented: $viewModel.isCameraPresented)
            .onChange(of: appState.capturedImage) { _, newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let img = newValue {
                        router.push(.detail)
                    }
                }
            }
            .navigationDestination(for: HomeRoute.self) { destination in
                switch destination {
                case .detail:
                    DetailView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .onAppear {
                // Ask Location
                if !viewModel.isAskedLocationPermission {
                    viewModel.isAskedLocationPermission = true
                    if !locationManager.checkPermission() {
                        locationManager.requestPermission()
                    }
                }

                // Paywall
                if !isPremium {
                    isPaywallPresented.toggle()
                }
            }
            .onAppearRequestTracking()
            .presentRCPaywallSheet(isPresented: $isPaywallPresented)
        }
    }
}
