//
//  NetworkAssembly.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import SwiftData
import Swinject

final class NetworkAssembly: @preconcurrency Assembly {
    @MainActor
    func assemble(container: Container) {
        // Supabase Response
        container.register(SupabaseRepository.self, factory: { _ in
            SupabaseRepositoryImpl()
        })

        // Supbase UseCase
        container.register(IdentifyUseCase.self) { _ in
            IdentifyUseCaseImpl()
        }

        container.register(SignInAnonymouslyUseCase.self) { _ in
            SignInAnonymouslyUseCaseImpl()
        }
    }
}
