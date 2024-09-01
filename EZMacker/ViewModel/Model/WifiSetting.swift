//
//  WifiSetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShowMode { get set }
}

struct WifiSetting: WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShowMode = .alert
}
