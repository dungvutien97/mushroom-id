//
//  LocationView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var showSettingsAlert = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .foregroundColor(.accentColor)
                .font(.footnote)

            if let location = locationManager.location {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lat: \(location.coordinate.latitude, specifier: "%.4f") • Lon: \(location.coordinate.longitude, specifier: "%.4f")")
                        .font(.footnote.monospacedDigit())
                        .foregroundColor(.accent)
                }
            } else {
                Button(action: {
                    switch locationManager.authorizationStatus {
                        case .denied, .restricted:
                            // Đã từ chối → hiện alert mở Settings
                            showSettingsAlert = true
                        default:
                            // Xin quyền lại
                            locationManager.requestPermission()
                    }
                }) {
                    Text("Allow")
                        .font(.caption.bold())
                        .cornerRadius(8)
                        .foregroundColor(.accentColor)
                }
                .alert("Location Permission Denied",
                       isPresented: $showSettingsAlert)
                {
                    Button("Cancel", role: .cancel) {}
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } message: {
                    Text("Please enable Location access in Settings to continue.")
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.white)
        )
        .onAppear {
            locationManager.startUpdating()
        }
    }
}

#Preview {
    let locationManager = LocationManager()
    LocationView()
        .environmentObject(locationManager)
}
