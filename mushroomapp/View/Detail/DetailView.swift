//
//  DetailView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 11/9/25.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: DetailViewModel = .init()
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var locationManager: LocationManager

    var body: some View {
        ZStack {
            MainContent()
            FooterView()
        }
        .onAppearInAppRating()
        .onAppear {
            viewModel.connect(appState: appState)
        }
    }

    @ViewBuilder
    func MainContent() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                // Ảnh minh họa
                if let image = appState.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                MushroomWarningBanner()

                ZStack {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.accent)
                            .padding()
                            .transition(.opacity.combined(with: .scale)) // hiệu ứng mượt
                    } else {
                        if let mushroom = viewModel.mushroom,
                           let attributes = mushroom.attributes
                        {
                            DetailAttributesView(attributes: attributes)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        } else {
                            ContentUnavailableView(
                                "No Mushroom Found",
                                systemImage: "exclamationmark.triangle",
                                description: Text("We couldn’t load mushroom details. Please try again.")
                            )
                            .transition(.opacity.combined(with: .scale))
                            .opacity(viewModel.isLoading ? 0 : 1)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
            }

            Spacer()
                .frame(height: 123)
        } //: SCROLLVIEW
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func FooterView() -> some View {
        VStack {
            Spacer()
            if !viewModel.isLoading && viewModel.mushroom != nil {
                Group {
                    if viewModel.isSaved {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Saved to My Map")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .transition(.scale.combined(with: .opacity)) // ✅ hiệu ứng
                    } else {
                        Button(action: {
                            withAnimation(.spring()) { // ✅ animate khi bấm
                                saveMushroom()
                            }
                        }) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text("Add to My Map")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0/255, green: 177/255, blue: 64/255))
                            .cornerRadius(8)
                        }
                        .transition(.scale.combined(with: .opacity)) // ✅ hiệu ứng
                    }
                }
                .animation(.spring(), value: viewModel.isSaved) // animate khi state đổi
            }
        }
        .padding(.horizontal)
    }

    // Helper View cho mỗi dòng
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .fontWeight(.semibold)
            Text(value)
                .multilineTextAlignment(.leading)
        }
        .font(.body)
    }

    // Functions
    private func saveMushroom() {
        // Convert Domain model -> SwiftData model

        guard let mushroom = viewModel.mushroom else { return }

        let sdAttributes = SDMushroomAttributes(
            id: UUID(),
            name: mushroom.attributes?.name,
            otherNames: mushroom.attributes?.otherNames,
            family: mushroom.attributes?.family,
            scientificName: mushroom.attributes?.scientificName,
            habitat: mushroom.attributes?.habitat,
            season: mushroom.attributes?.season,
            region: mushroom.attributes?.region,
            capShape: mushroom.attributes?.capShape,
            capColour: mushroom.attributes?.capColour,
            capDiameter: mushroom.attributes?.capDiameter,
            stemHeight: mushroom.attributes?.stemHeight,
            stemWidth: mushroom.attributes?.stemWidth,
            gillAttachment: mushroom.attributes?.gillAttachment,
            gillColour: mushroom.attributes?.gillColour,
            distinctiveFeatures: mushroom.attributes?.distinctiveFeatures,
            sporeColour: mushroom.attributes?.sporeColour,
            sporePrintNotes: mushroom.attributes?.sporePrintNotes,
            smellTaste: mushroom.attributes?.smellTaste,
            edibility: mushroom.attributes?.edibility,
            toxicityWarning: mushroom.attributes?.toxicityWarning,
            edibilityNotes: mushroom.attributes?.edibilityNotes
        )

        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude

        let sdMushroom = SDMushroom(
            id: mushroom.id,
            lat: lat,
            long: lon,
            createdAt: mushroom.createdAt
        )

        sdMushroom.imageData = appState.capturedImage?.jpegData(compressionQuality: 1)
        sdMushroom.attributes = sdAttributes

        context.insert(sdMushroom)

        do {
            try context.save()
            print("✅ Mushroom saved to SwiftData")

            viewModel.isSaved = true
        } catch {
            print("❌ Failed to save mushroom: \(error)")
        }
    }
}
