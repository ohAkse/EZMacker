import SwiftUI

struct SmartBatteryView<ProvidableType>: View where ProvidableType: AppSmartBatteryRegistryProvidable {
    //ObservedObject는 갱신하면 파괴후 다시 생성하면서 타이머 돌린게 바로 업데이트 안됨
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel<ProvidableType>
    @State private var toast: Toast?
    @State private var isAdapterAnimated = false
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        VStack(alignment:.leading, spacing:0) {
                            if smartBatteryViewModel.isAdapterConnected  {
                                if smartBatteryViewModel.currentBatteryCapacity * 100 == 100 {
                                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지", info: "충전완료", widthScale:0.3, heightScale:0.7)
                                }
                                else {
                                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지 ", info: smartBatteryViewModel.chargingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                }
                            } else {
                                if smartBatteryViewModel.chargingTime <= 1  {
                                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지 ", info: smartBatteryViewModel.remainingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                }
                            }
                        }
                        .onReceive(smartBatteryViewModel.$isAdapterConnected) { isConnected in
                            if isConnected {
                                toast = Toast(type: .info, title: "정보", message: "배터리 종료/충전 시간은 시스템 구성에 따라 최대 5분이 소요됩니다.", duration: 10)
                            }
                        }
                        .frame(width: geo.size.width * 0.2, height:geo.size.height * 0.2)
                        
                        Spacer()
                        HStack(alignment: .top) {
                            VStack(alignment: .trailing) {
                                Text("Max V")
                                    .lineLimit(1)
                                    .fixedSize()
                                Spacer()
                                Text("Min V")
                                    .lineLimit(1)
                                    .fixedSize()
                            }
                            .offset(x: 20)
                            .padding(.vertical)
                            
                            
                            InfoGridHMonitoringView(chargeData: $smartBatteryViewModel.chargeData)
                                .padding()
                                .frame(width: geo.size.width * 0.72)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top, spacing: 0) {
                                    Spacer(minLength: 0)
                                    Image("battery_setting")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .background(Color.clear)
                                        .onTapGesture {
                                            smartBatteryViewModel.openSettingWindow(settingPath: SystemPreference.batterySave.pathString)
                                        }
                                }
                                .offset(x: -40,y: -20)
                            }
                        }
                        .frame(width: geo.size.width * 0.72)
                    }
                }
                .frame( height: geo.size.height * 0.2)
                
                
                if smartBatteryViewModel.isAdapterConnected {
                    HStack {
                        if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                            if isAdapterAnimated {
                                VStack {
                                    CustomImage(systemName: "battery_adapter", isSystemName: false)
                                    CustomContent(content: adapterInfo.Name)
                                }
                                .padding(.bottom, 5)
                                VStack(spacing:0){
                                    Spacer()
                                    InfoElipseHImageView(title: "어댑터ID", content: "\(adapterInfo.AdapterID)")
                                    Spacer()
                                    InfoElipseHImageView(title: "모델ID", content: "\(adapterInfo.Model)")
                                    Spacer()
                                    InfoElipseHImageView(title: "펌웨어버전", content: "\(adapterInfo.FwVersion)")
                                    Spacer()
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                }
                                .frame(width: geo.size.width * 0.4)
                                .foregroundColor(ThemeColor.lightGray.color)
                                Spacer(minLength: 20)
                                VStack(spacing: 0) {
                                    Spacer()
                                    InfoElipseHImageView(title: "제조사", content: "\(adapterInfo.Manufacturer)")
                                    Spacer()
                                    InfoElipseHImageView(title: "와츠", content: "\(adapterInfo.Watts)" + "W")
                                    Spacer()
                                    InfoElipseHImageView(title: "하드웨어버전", content: "\(adapterInfo.HwVersion)")
                                    Spacer()
                                }
                                .frame(width: geo.size.width * 0.4)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                }
                                .foregroundColor(ThemeColor.lightGray.color)
                            }
                        }
                    }
                    .onAppear{
                        withAnimation(.spring(duration: 1)) {
                            isAdapterAnimated.toggle()
                        }
                    }
                    .onDisappear{
                        withAnimation(.easeOut(duration: 1)) {
                            isAdapterAnimated.toggle()
                        }
                    }
                }
                else {
                    if smartBatteryViewModel.adapterConnectionSuccess == .decodingFailed  {
                        HStack(alignment:.center ,spacing:0){
                            HStack(spacing: 0) {
                                WGifView(gifName: "global_loading", imageSize: CGSize(width: geo.size.width * 0.4, height: geo.size.height * 0.4))
                                    .frame(width:geo.size.width * 0.4, height: geo.size.height * 0.4)
                                Spacer()
                                Text("정보를 수집중입니다. 잠시만 기다려 주세요.")
                                    .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                                Spacer()
                            }
                        }
                        .frame(height: geo.size.height * 0.4)
                    }
                    else {
                        
                        HStack(alignment:.center ,spacing:0){
                            
                            VStack(alignment: .center) {
                                WGifView(gifName: "battery_adapter_plugin_animation", imageSize: CGSize(width: 50, height: 50))
                                Spacer(minLength: 10)
                                Text("어댑터를 꽃으면 정보가 나와요!")
                                    .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                                    .shadow(radius: 5)
                                
                            }.frame(width: geo.size.width * 0.5)
                            
                            VStack(spacing: 0) {
                                InfoRectangleHImageTextView(imageName: "battery_status",isSystem: false, title: "배터리 상태", info: smartBatteryViewModel.healthState == "" ? "계산중.." : smartBatteryViewModel.healthState,widthScale:0.2, heightScale:0.5)
                                    .frame(height:geo.size.height * 0.2)
                                InfoRectangleHImageTextView(imageName: "battery_cell",isSystem: false, title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)",widthScale:0.2, heightScale:0.5)
                                    .frame(height:geo.size.height * 0.2)
                            }

                        }
                        .frame(height: geo.size.height * 0.4)
                        .onAppear{
                            withAnimation(.spring(duration: 1)) {
                                isAdapterAnimated.toggle()
                            }
                        }
                        .onDisappear{
                            withAnimation(.default) {
                                isAdapterAnimated.toggle()
                            }
                        }
                    }
                }
                InfoBatteryBarView(batteryLevel: $smartBatteryViewModel.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.isAdapterConnected)
                    .frame( height: 50)
                    .padding(.top, 10)
                HStack(spacing: 30) {
                    InfoRectangleHImageTextView(imageName: "battery_recycle",isSystem: false, title: "사이클 수", info: smartBatteryViewModel.cycleCount.toBun(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_thermometer", isSystem: false, title: "온도", info: smartBatteryViewModel.temperature.toDegree(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_currentCapa", isSystem: false, title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_designdCapa", isSystem: false, title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                }
                .padding(.top, 20)
                Spacer()
            }
            .onAppear {
                smartBatteryViewModel.requestStaticBatteryInfo()
                smartBatteryViewModel.startConnectTimer()
                smartBatteryViewModel.checkAdapterConnectionStatus()
            }
            .onDisappear {
                smartBatteryViewModel.stopConnectTimer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(CategoryType.smartBattery.title)
            .padding(30)
            .toastView(toast: $toast)
        }
    }
}

extension SmartBatteryView {
    private func getBatteryImageName() -> String {
        if smartBatteryViewModel.isAdapterConnected {
            if smartBatteryViewModel.currentBatteryCapacity == 1 {
                return "battery_full_charge"
            } else {
                return "battery_charging"
            }
        } else {
            switch smartBatteryViewModel.currentBatteryCapacity {
            case 1:
                return "battery_full"
            case 0.67...0.99:
                return  "battery_high"
            case 0.34...0.66:
                return  "battery_normal"
            case 0...0.33:
                return  "battery_low"
            default:
                Logger.fatalErrorMessage("Unknown Battery Level")
            }
        }
        return ""
    }
}

//struct SmartBatteryView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService(serviceKey: "AppleSmartBattery"), systemPreferenceService: SystemPreferenceService()))
//            .frame(width: 1500,height:1000)
//    }
//}
