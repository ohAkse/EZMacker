//
//  RadioChannelData.swift
//  EZMacker
//
//  Created by 박유경 on 8/24/24.
//

import Foundation

struct RadioChannelData: Equatable {
    var channelBandwidth: Int
    var channelFrequency: Int
    var channel: Int
    var band: String
    var locale: String
    var macAddress: String
    init(channelBandwidth: Int = 0, channelFrequency: Int = 0, channel: Int = 0, band: String = "", locale: String = "", hardwareAddress: String = "") {
        self.channelBandwidth = channelBandwidth
        self.channelFrequency = channelFrequency
        self.channel = channel
        self.band = band
        self.locale = locale
        self.macAddress = hardwareAddress
    }
}
