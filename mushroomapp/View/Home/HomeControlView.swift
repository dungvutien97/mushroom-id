//
//  HomeControlView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 9/9/25.
//

import SwiftData
import SwiftUI

struct HomeControlView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var router: HomeRouter
    @Query(sort: \SDMushroom.createdAt, order: .reverse) var mushrooms: [SDMushroom]
    @State private var number: Int = 0
    @EnvironmentObject private var locationManager: LocationManager

    var body: some View {
        VStack {
            Spacer()

            HStack {
                // Settings
                Button {
                    router.push(.settings)
                } label: {
                    Image(systemName: "gear") // icon mặc định Apple
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }

                // History
                Button {
                    router.push(.history)
                } label: {
                    Image(systemName: "clock") // icon mặc định Apple
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                
                Spacer()
                
                LocationView()
                
            }

            VStack(spacing: 12) {
                // Thông tin số lượng nấm detect
                VStack(spacing: 4) {
                    Text("Detected \(number)")
                        .font(.title2).bold()
                        .foregroundColor(.black)
                        .contentTransition(.numericText(value: Double(number))) // Animate the number change

                    Text("Mushrooms identified so far")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onAppear {
                    withAnimation(.smooth.delay(0.5)) { // Apply animation to the state change
                        number = mushrooms.count
                    }
                }

                // Nút Identify
                Button(action: {
                    viewModel.isCameraPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "sparkle.magnifyingglass")
                        Text("Identify")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0/255, green: 177/255, blue: 64/255)) // xanh lá giống hình
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
            .padding(.bottom, 12)
        } //: VSTACK
        .padding(.horizontal)
    }
}

// #Preview {
//    HomeControlView()
// }
