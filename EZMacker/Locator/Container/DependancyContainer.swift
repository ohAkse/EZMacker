//
//  DependancyContainer.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import SwiftData

protocol DependencyRegisterable {
    func register(in container: DependencyContainer)
}

class DependencyContainer {
    static let shared = DependencyContainer()
    private var dependencies: [String: Any] = [:]
    private var modelContext: ModelContext?
    
    private init() {}
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func register<T>(_ dependency: @escaping (ModelContext?) -> T, forKey key: String) {
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type, forKey key: String) -> T {
        guard let dependency = dependencies[key] as? (ModelContext?) -> T else {
            fatalError("Dependency not found for key: \(key)")
        }
        return dependency(modelContext)
    }
}
