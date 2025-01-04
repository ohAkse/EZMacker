//
//  EZWifiMainView.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import SwiftUI
import CoreWLAN
import EZMackerUtilLib
import EZMackerServiceLib

struct EZWifiMainView: View {
    @Binding var ssid: String
    @Binding var wifiLists: [ScaningWifiData]
    @Binding var isRefreshing: Bool
    @Binding var isFindingBestWifi: Bool
    @State private var password: String = ""
    @State private var isShowingPasswordModal = false
    @State private var toast: ToastData?
    @State private var selectedSSid: String = ""
    private(set) var appSmartAutoconnectWifiService: AppSmartAutoconnectWifiServiceProvidable
    private(set) var onRefresh: () -> Void
    private(set) var onWifiTap: (String, String) -> Void
    private(set) var onFindBestWifi: () -> Void
    private(set) var onMoreInfo: () -> Void
    
    init(appSmartAutoconnectWifiService: AppSmartAutoconnectWifiServiceProvidable,
         ssid: Binding<String> = .constant(""),
         wifiLists: Binding<[ScaningWifiData]> = .constant([]),
         isRefreshing: Binding<Bool> = .constant(false),
         isFindingBestWifi: Binding<Bool> = .constant(false),
         onRefresh: @escaping () -> Void = {},
         onWifiTap: @escaping (String, String) -> Void = { _, _ in },
         onFindBestWifi: @escaping () -> Void = {},
         onMoreInfo: @escaping () -> Void = {}) {
        self.appSmartAutoconnectWifiService = appSmartAutoconnectWifiService
        self._ssid = ssid
        self._wifiLists = wifiLists
        self._isRefreshing = isRefreshing
        self._isFindingBestWifi = isFindingBestWifi
        self.onRefresh = onRefresh
        self.onWifiTap = onWifiTap
        self.onFindBestWifi = onFindBestWifi
        self.onMoreInfo = onMoreInfo
    }
    // MARK: Refresh의 경우 Disabled 처리가 빨리 처리가 되어 깜빡이는것처럼 보여서 일단 처리 안함
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Spacer()
                    EZImageView(systemName: "wifi_router", isSystemName: false)
                        .frame(height: 200)
                    Spacer(minLength: 0)
                    Text("\(ssid)")
                        .frame(height: 30)
                        .ezNormalTextStyle(fontSize: FontSizeType.medium.size, isBold: true)
                    Spacer()
                }
                .frame(width: 200, height: 280)
                .padding([.leading, .trailing], 20)
                .padding(.top, 10)
                
                Spacer()
                if wifiLists.isEmpty {
                    HStack(alignment: .center) {
                        EZLoadingView(size: 200, text: "Wifi 리스트 불러오는 중..")
                    }
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        Spacer()
                        EZButtonActionView(
                            action: { didTapWifiListWithAscending() },
                            imageName: "arrowshape.up.fill",
                            isDisabled: false
                        )
                        Spacer()
                        EZButtonActionView(
                            action: { didTapWifiListWithDescending() },
                            imageName: "arrowshape.down.fill",
                            isDisabled: false
                        )
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            #if USE_PRIVATE_FUNC
                            EZButtonActionView(
                                action: {
                                    onMoreInfo()
                                },
                                imageName: "info.windshield",
                                isDisabled: false
                            )
                            .padding(.trailing, 5)
                            #endif
                            
                            EZButtonActionView(
                                action: {
                                    onRefresh()
                                    Logger.writeLog(.info, message: "isRefreshing: \(isRefreshing)")
                                },
                                imageName: "rays",
                                isDisabled: isRefreshing || isFindingBestWifi
                            )
                            .padding(.trailing, 5)
                            
                            EZButtonActionView(
                                action: {
                                    onFindBestWifi()
                                    toast = ToastData(type: .info, message: "최적의 와이파이를 찾고 있습니다.")
                                },
                                imageName: "arrow.clockwise.circle",
                                isDisabled: isRefreshing || isFindingBestWifi)
                        }
                        .padding([.trailing], 10)
                        List {
                            ForEach(wifiLists) { wifi in
                                HStack {
                                    Image(systemName: "wifi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text(wifi.ssid)
                                        .font(.headline)
                                    Spacer()
                                    Text("RSSI: \(wifi.rssi)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    #if NO_NEED_MONITORING
                                    Text("B.I: \(wifi.beaconInterval ?? 0)ms")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    #endif
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    validateWifiTap(wifi)
                                }
                            }
                            .ezListRowStyle()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                        .ezBackgroundStyle()
                        .ezListViewStyle()
                        .padding(10)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundStyle()
        .clipped()
        .sheet(isPresented: $isShowingPasswordModal) {
            AlertTextFieldView(
                textFieldValue: $password,
                isPresented: $isShowingPasswordModal,
                ssid: selectedSSid,
                title: "와이파이 접속",
                subtitle: "비밀번호를 입력해주세요.",
                onOk: {
                    Logger.writeLog(.info, message: selectedSSid)
                    Logger.writeLog(.info, message: password)
                    onWifiTap(selectedSSid, password)
                }
            )
        }
        .toastView(toast: $toast)
    }
    
    private func validateWifiTap(_ wifi: ScaningWifiData) {
        if let savedPassword = appSmartAutoconnectWifiService.getPassword(for: wifi.ssid) {
            connectToWifi(ssid: wifi.ssid, password: savedPassword)
        } else {
            showPasswordModal(for: wifi.ssid)
        }
    }
    
    private func showPasswordModal(for ssid: String) {
        selectedSSid = ssid
        isShowingPasswordModal = true
    }
    
    private func connectToWifi(ssid: String, password: String) {
        onWifiTap(ssid, password)
    }
    
    private func didTapWifiListWithAscending() {
        withAnimation {
            wifiLists = wifiLists.sorted { Int($0.rssi)! < Int($1.rssi)! }
        }
    }
    
    private func didTapWifiListWithDescending() {
        withAnimation {
            wifiLists = wifiLists.sorted { Int($0.rssi)! > Int($1.rssi)! }
        }
    }
}
