//
//  SmartImageTunerDependency.swift
//  EZMacker
//
//  Created by 박유경 on 9/28/24.
//
import EZMackerImageLib

struct SmartImageTunerDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register({ _ in  ImageProcessWrapper() as ImageProcessWrapperProvidable }, forKey: ImageTunerWrapperKey.imageSender.rawValue, lifetime: .transient)
    }
}
