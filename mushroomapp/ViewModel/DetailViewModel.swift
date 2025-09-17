//
//  DetailViewModel.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 13/9/25.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var mushroom: Mushroom? = nil
    @Published var isLoading: Bool = true
    
    @Published var isSaved: Bool = false

    @Inject private var identifyUseCase: IdentifyUseCase
    
    private var appState: AppState?
    
    func connect(appState: AppState) {
        self.appState = appState
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        if mushroom != nil { return }
        
        print("Fetch mushroom data")

        isLoading = true
        defer { isLoading = false }
        
        guard let image = appState?.capturedImage?.resized(by: 0.6) else { return }
        
        do {
            let response: MushroomAttributes = try await identifyUseCase.execute(image: image, name: "")
            
            // Chỉ cần lấy được attributes thôi, còn lại ở view sẽ cập nhật lại
            let item = Mushroom(id: UUID(),
                                lat: 0,
                                long: 0,
                                imageData: nil,
                                attributes: response,
                                createdAt: Date())
            
            mushroom = item
            
        } catch(let e) {
            print("Lỗi: \(e.localizedDescription)")
        }
    }
}
