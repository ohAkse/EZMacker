//
//  MacModelIdentifier.swift
//  EZMacker
//
//  Created by 박유경 on 9/7/24.
//

import Foundation

enum MacBookType {
    case macBookPro
    case macBookAir
    case macMini
    
    static func from(identifier: String) -> MacBookType {
        switch identifier {
        case _ where MacBookType.macBookProIdentifiers.contains(identifier):
            return .macBookPro
        case _ where MacBookType.macBookAirIdentifiers.contains(identifier):
            return .macBookAir
        default:
            return .macMini
        }
    }
    
    private static let macBookProIdentifiers: Set<String> = [
        "Mac15,7", "Mac15,8", "Mac15,9", "Mac15,10", // M3 Pro/Max (2023)
        "Mac14,9", "Mac14,10", // M2 Pro/Max (2023)
        "Mac14,7", // M2 13-inch (2022)
        "Mac14,5", "Mac14,6", // M2 Pro/Max (2022)
        "Mac13,1", "Mac13,2", // M1 Pro/Max (2021)
        "MacBookPro17,1", // M1 (2020)
        "MacBookPro16,1", "MacBookPro16,2", "MacBookPro16,3", "MacBookPro16,4", // Intel (2019)
        "MacBookPro15,1", "MacBookPro15,2", "MacBookPro15,3", "MacBookPro15,4"  // Intel (2018-2019)
    ]
    
    private static let macBookAirIdentifiers: Set<String> = [
        "Mac15,3", "Mac15,4", "Mac15,5", // M3 (2024)
        "Mac14,2", // M2 (2022)
        "MacBookAir10,1", // M1 (2020)
        "MacBookAir9,1", // Intel (2020)
        "MacBookAir8,1", "MacBookAir8,2", // Intel (2018-2019)
        "MacBook10,1", // Intel (2017)
        "MacBook9,1", // Intel (2016)
        "MacBook8,1"  // Intel (2015)
    ]
}
