//
//  HistoryView.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \SDMushroom.createdAt, order: .reverse) var mushrooms: [SDMushroom]
    @State private var selectedMushroomID: UUID?
    @EnvironmentObject private var appState: AppState
    @State private var selectedMushroom: SDMushroom? = nil

    var groupedMushrooms: [(date: Date, items: [SDMushroom])] {
        let grouped = Dictionary(grouping: mushrooms) { mushroom in
            Calendar.current.startOfDay(for: mushroom.createdAt)
        }
        .map { key, value in
            (date: key, items: value)
        }
        .sorted { $0.date > $1.date }

        return grouped
    }

    var body: some View {
        ZStack {
            List {
                ForEach(groupedMushrooms, id: \.date) { section in
                    Section(header: Text(section.date, style: .date)) {
                        ForEach(section.items) { mushroom in
                            HistoryItemView(mushroom: mushroom)
                        }
                        .onDelete { indexSet in
                            deleteMushroom(at: indexSet, in: section.items)
                        }
                    }
                }
            } //: LIST VIEW
            .listStyle(.plain)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        } //: ZSTACK
        .sheet(item: $selectedMushroom) { _ in
            HistoryDetailedView()
        }
        .navigationTitle("History")
    }

    private func deleteMushroom(at offsets: IndexSet, in items: [SDMushroom]) {
        for index in offsets {
            let mushroom = items[index]
            context.delete(mushroom)
        }
        try? context.save()
    }

    @ViewBuilder
    func HistoryItemView(mushroom: SDMushroom) -> some View {
        HStack {
            if let imageData = mushroom.imageData,
               let uiImage = UIImage(data: imageData)
            {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image("mushrooms-ic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.accent)
            }

            VStack(alignment: .leading) {
                Text(mushroom.attributes?.name ?? "Unknown")
                    .font(.headline)
                Text(mushroom.createdAt, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .contentShape(Rectangle()) // tap toàn row
        .onTapGesture {
            withAnimation(.easeInOut) {
                // Lưu lại để lấy từ detail cho dễ
                 appState.selectedMushroom = mushroom.asDomain()
                
                // For toggle
                self.selectedMushroom =  mushroom
                
                // Logic cho hiệu ứng highlight khi chọn item
                if selectedMushroomID == mushroom.id {
                    selectedMushroomID = nil
                } else {
                    selectedMushroomID = mushroom.id
                }
            }
        }
        .listRowBackground(
            selectedMushroomID == mushroom.id ? Color.accentColor.opacity(0.1) : Color.clear
        )
    }
}
