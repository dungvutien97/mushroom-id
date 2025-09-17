//
//  DIContainer.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import Foundation
import SwiftData
import Swinject

protocol DIContainerProtocol {
    func resolve<T>(_ type: T.Type) -> T
    func resolve<T>(_ type: T.Type, name: String?) -> T
    func reset()
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()
    private let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        assembler = Assembler([
            NetworkAssembly()
        ], container: container)
    }
    
    func reset() {
        container.removeAll()
    }
    
    // MARK: - Helper Methods
    
    @MainActor
    func setupMainContext(_ context: ModelContext) {
        container.register(ModelContext.self) { _ in
            context
        }.inObjectScope(.container)
    }
}

extension DIContainer {
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("\(type) dependency could not be resolved")
        }
        return dependency
    }
    
    func resolve<T>(_ type: T.Type, name: String?) -> T {
        guard let dependency = container.resolve(type, name: name) else {
            fatalError("\(type) dependency with name \(name ?? "") could not be resolved")
        }
        return dependency
    }
}
