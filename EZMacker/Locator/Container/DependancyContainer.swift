//
//  DependancyContainer.swift
//  EZMacker
//
//  Created by 박유경 on 9/17/24.
//

import Foundation
import SwiftData

enum DependencyLifetime {
    case singleton
    case transient
}

class DependencyContainer {
    static let shared = DependencyContainer()
    private var dependencies: [String: (lifetime: DependencyLifetime, factory: (ModelContext?) -> Any)] = [:]
    private var singletonInstances: [String: Any] = [:]
    private var modelContext: ModelContext?
    
    private init() {}
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func register<T>(_ dependency: @escaping (ModelContext?) -> T, forKey key: String, lifetime: DependencyLifetime) {
        dependencies[key] = (lifetime: lifetime, factory: dependency)
    }
    
    func resolve<T>(_ type: T.Type, forKey key: String) -> T {
        guard let dependencyInfo = dependencies[key] else {
            fatalError("Dependency not found for key: \(key)")
        }
        
        switch dependencyInfo.lifetime {
         case .singleton:
             if let instance = singletonInstances[key] as? T {
                 return instance
             }
             guard let newInstance = dependencyInfo.factory(modelContext) as? T else {
                 fatalError("Failed to create instance for key: \(key)")
             }
             singletonInstances[key] = newInstance
             return newInstance
             
         case .transient:
             guard let instance = dependencyInfo.factory(modelContext) as? T else {
                 fatalError("Failed to create instance for key: \(key)")
             }
             return instance
         }
    }
}
