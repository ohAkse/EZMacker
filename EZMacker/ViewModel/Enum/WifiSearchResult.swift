//
//  WifiSearchResult.swift
//  EZMacker
//
//  Created by 박유경 on 3/9/25.
//

struct WiFiSearchResult {
    var isBestCase: Bool
    
    init(isBestCase: Bool) {
        self.isBestCase = isBestCase
    }
    var titleText: String {
          return isBestCase ? "최적의 와이파이" : "최악의 와이파이"
    }
    
    func getResult(_ ssid: String) -> String {
        return "\(titleText)\(ssid)"
    }
}
