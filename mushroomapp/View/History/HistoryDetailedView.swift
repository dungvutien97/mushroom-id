//
//  HistoryDetailedView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftData
import SwiftUI

struct HistoryDetailedView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: HistoryDetailedViewModel = .init()
    @Environment(\.modelContext) private var context
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            MainContent()
            FooterView()
        }
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
                }
            }

            Spacer()
                .frame(height: 123)
        } //: SCROLLVIEW
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        // ✅ Alert xác nhận
        .alert("Remove Mushroom", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                withAnimation(.spring()) {
                    removeMushroom()
                }
            }
        } message: {
            Text("Are you sure you want to remove this mushroom from your map and history?")
        }
    }

    @ViewBuilder
    func FooterView() -> some View {
        VStack {
            Spacer()
            Group {
                if viewModel.isRemoved {
                    // ✅ trạng thái đã xoá
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Removed from Map & History")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
                } else {
                    // ✅ trạng thái chưa xoá
                    Button(action: {
                        withAnimation(.spring()) {
                            showDeleteAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "mappin.slash")
                            Text("Remove from My Map")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 220/255, green: 0/255, blue: 0/255)) // đỏ cho "Remove"
                        .cornerRadius(8)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(), value: viewModel.isRemoved)
        }
        .padding(.horizontal)
    }

    // Functions
    private func removeMushroom() {
        guard let id = viewModel.mushroom?.id else { return }

        // Tìm mushroom theo id
        let descriptor = FetchDescriptor<SDMushroom>(
            predicate: #Predicate { $0.id == id }
        )

        if let mushroom = try? context.fetch(descriptor).first {
            context.delete(mushroom)
            try? context.save()

            viewModel.isRemoved = true
        }
    }
}
