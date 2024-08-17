//
//  WifiSetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShow { get set }
}

struct WifiSetting: WifiSettingConfigurable {
    var selectedBestSSIDOption: BestSSIDShow = .alert
}

