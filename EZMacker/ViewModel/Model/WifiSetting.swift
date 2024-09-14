//
//  WifiSetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShowType { get set }
}

struct WifiSetting: WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShowType = .alert
}
