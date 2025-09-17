//
//  InjectWrapper.swift
//  mushroomapp
//
//  Created by Tien Dung Vu on 14/9/25.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<T> {
    private var service: T
    
    init() {
        self.service = DIContainer.shared.resolve(T.self)
    }
    
    var wrappedValue: T {
        service
    }
}
