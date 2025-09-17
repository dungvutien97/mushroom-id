//
//  CustomMapView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 9/9/25.
//

import MapKit
import SwiftData
import SwiftUI

struct MushroomMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // fallback: San Francisco (US)
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var selectedType: MapDisplayType = .satellite
    @Query(filter: #Predicate<SDMushroom> { $0.lat != nil })
    var mushrooms: [SDMushroom]
    
    @StateObject private var locationManager = LocationManager()
    @State private var hasCenteredOnUser = false
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: mushrooms
            ) { mushroom in
                MapAnnotation(coordinate: mushroom.coordinate) {
                    MushroomAnnotationView(mushroom: mushroom)
                }
            }
            .mapStyle(selectedType.mapStyle)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Picker("Map Type", selection: $selectedType) {
                        ForEach(MapDisplayType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .font(.footnote)
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .tint(.accentColor)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            locationManager.requestPermission()
        }
        // ✅ chỉ focus 1 lần khi có vị trí đầu tiên
        .onReceive(locationManager.$lastLocation) { location in
            if let loc = location, !hasCenteredOnUser {
                region = MKCoordinateRegion(
                    center: loc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                hasCenteredOnUser = true
            }
        }
    }
}
