//
//  SignInAnonymously.swift
//  poca
//
//  Created by Tien Dung Vu on 1/6/25.
//

import Foundation
import UIKit

protocol SignInAnonymouslyUseCase {
    func execute() async throws -> Void
}

struct SignInAnonymouslyUseCaseImpl: SignInAnonymouslyUseCase {

    @Inject private var repository: SupabaseRepository
    
    func execute() async throws {
        try await repository.signInAnonymously()
    }
}

