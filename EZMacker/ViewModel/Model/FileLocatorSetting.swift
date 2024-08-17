//
//  FileLocatorSetting.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

protocol FileLocatorSettingConfigurable {
    var isFileChangeAlarmDisabled: Bool { get set }
}

struct FileLocatorSetting: FileLocatorSettingConfigurable {
    var isFileChangeAlarmDisabled: Bool = false
}
