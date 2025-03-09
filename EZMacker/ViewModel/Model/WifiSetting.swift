//
//  WifiSetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol WifiSettingConfigurable {
    var selectedSSIDShowOption: SSIDShowType { get set }
    var ssidFindTimer: String { get set }
}

struct WifiSetting: WifiSettingConfigurable {
    var selectedSSIDShowOption: SSIDShowType = .alert
    var ssidFindTimer: String = "5"
}
