//
//  IdentifyUseCase.swift
//  poca
//
//  Created by Tien Dung Vu on 1/6/25.
//

import Foundation
import UIKit

protocol IdentifyUseCase {
    func execute(image: UIImage, name: String) async throws -> MushroomAttributes
}

struct IdentifyUseCaseImpl: IdentifyUseCase {

    @Inject private var repository: SupabaseRepository
    
    func execute(image: UIImage, name: String) async throws -> MushroomAttributes {
        try await repository.invoke(image: image, name: name)
    }
}

