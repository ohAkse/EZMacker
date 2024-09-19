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
    @EnvironmentObject var colorSchemeViewModel: AppToolbarViewModel
    @Binding var ssid: String
    @Binding var wifiLists: [ScaningWifiData]
    @State private var password: String = ""
    @State private var isShowingPasswordModal = false
    @State private var toast: ToastData?
    @State private var selectedSSid: String = ""
    private(set) var appSmartAutoconnectWifiService: AppSmartAutoconnectWifiServiceProvidable
    private(set) var onRefresh: () -> Void
    private(set) var onWifiTap: (String, String) -> Void
    private(set) var onFindBestWifi: () -> Void
    
    init(appSmartAutoconnectWifiService: AppSmartAutoconnectWifiServiceProvidable,
         ssid: Binding<String> = .constant(""),
         wifiLists: Binding<[ScaningWifiData]> = .constant([]),
         onRefresh: @escaping () -> Void = {},
         onWifiTap: @escaping (String, String) -> Void = { _, _ in },
         onFindBestWifi: @escaping () -> Void = {}) {
        self.appSmartAutoconnectWifiService = appSmartAutoconnectWifiService
        self._ssid = ssid
        self._wifiLists = wifiLists
        self.onRefresh = onRefresh
        self.onWifiTap = onWifiTap
        self.onFindBestWifi = onFindBestWifi
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "wifi.router.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    Text("\(ssid)")
                        .ezNormalTextStyle(fontSize: FontSizeType.medium.size, isBold: true)
                    Spacer()
                }
                .frame(width: 200, height: 300)
                .padding([.leading, .trailing], 20)
                .padding(.top, 60)
                
                Spacer()
                if wifiLists.isEmpty {
                    HStack(alignment: .center) {
                        EZLoadingView(size: 200, text: "Wifi 리스트 불러오는 중..")
                    }
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            didTapWifiListWithAscending()
                        }, label: {})
                            .ezButtonImageStyle(imageName: "arrowshape.up.fill")
                        Spacer()
                        Button(action: {
                            didTapWifiListWithDescending()
                        }, label: {})
                            .ezButtonImageStyle(imageName: "arrowshape.down.fill")
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                onRefresh()
                            }, label: {})
                                .ezButtonImageStyle(imageName: "rays")
                                .padding(.trailing, 5)
                            Button(action: {
                                onFindBestWifi()
                                toast = ToastData(type: .info, title: "정보", message: "최적의 와이파이를 찾고 있습니다.")
                                
                            }, label: {})
                                .ezButtonImageStyle(imageName: "arrow.clockwise.circle")
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
                        .ezBackgroundColorStyle()
                        .ezListViewStyle()
                        .padding(10)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ezBackgroundColorStyle()
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
        wifiLists = wifiLists.sorted { Int($0.rssi)! < Int($1.rssi)! }
    }
    
    private func didTapWifiListWithDescending() {
        wifiLists = wifiLists.sorted { Int($0.rssi)! > Int($1.rssi)! }
    }
}
