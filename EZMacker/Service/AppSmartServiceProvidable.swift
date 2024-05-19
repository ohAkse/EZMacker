//
//  AppSmartServiceProvidable.swift
//  EZMacker
//
//  Created by 박유경 on 5/19/24.
//

import Combine
protocol AppSmartServiceProvidable {
    associatedtype KeyType
    var serviceKey: String { get }
    func getRegistry(forKey key: KeyType) -> Future<Any?, Never>
}
