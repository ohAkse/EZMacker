//
//  AppSmartServiceProvidable.swift
//  EZMackerServiceLib
//
//  Created by 박유경 on 9/1/24.
//
import Combine

public protocol AppSmartServiceProvidable {
    associatedtype KeyType
    var serviceKey: String { get }
    func getRegistry(forKey key: KeyType) -> Future<Any?, Never>
}
