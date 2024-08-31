//
//  AdapterMetricsData.swift
//  EZMacker
//
//  Created by 박유경 on 8/31/24.
//

import Foundation

struct AdapterMetricsData {
    var adapterData: [AdapterData]
    var adapterConnectionSuccess: AdapterConnect
    var isAdapterConnected: Bool
    init(adapterData: [AdapterData] = .init(), adapterConnectionSuccess: AdapterConnect = .none, isAdapterConnected: Bool = false ) {
        self.adapterData = adapterData
        self.adapterConnectionSuccess = adapterConnectionSuccess
        self.isAdapterConnected = isAdapterConnected
    }
}
