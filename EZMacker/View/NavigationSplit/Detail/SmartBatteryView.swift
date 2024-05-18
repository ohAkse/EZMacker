import SwiftUI

struct SmartBatteryView: View {
    //ObservedObject는 갱신하면 파괴후 다시 생성하면서 타이머 돌린게 바로 업데이트 안됨
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel
    @AppStorage(AppStorageKey.colorSchme.name) var colorScheme: String = AppStorageKey.colorSchme.byDefault
    @State private var toast: Toast?
    @State private var isAdapterAnimated = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        VStack(alignment:.leading, spacing:0) {
                            if smartBatteryViewModel.isAdapterConnected  {
                                if smartBatteryViewModel.currentBatteryCapacity * 100 == 100 {
                                    InfoRectangleHImageTextView(imageName: "battery_cell", isSystem: false, title: "충전 완료! ", info: "", widthScale:0.3, heightScale:0.7)
                                }
                                else {
                                    InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "완충까지 ", info: smartBatteryViewModel.chargingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                }
                            } else {
                                InfoRectangleHImageTextView(imageName: getBatteryImageName(), isSystem: false, title: "종료까지 ", info: smartBatteryViewModel.remainingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)   
                            }
                        }
                        .frame(width: geo.size.width * 0.37, height:geo.size.height * 0.2)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack(alignment: .top, spacing: 0) {
                                Spacer(minLength: 0)
                                Image(systemName: "exclamationmark.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .background(Color.clear)
                                
                                Text("계산까지 약 1분 소요")
                                    .customNormalTextFont(fontSize: FontSizeType.small.size, isBold: true)
                                    .frame(minWidth: geo.size.width * 0.11)
                                    .lineLimit(2)
                                    .padding(.leading, 10)
                                    .padding(.top, 5)
                            }
                            .padding(.trailing, 10)
                            Spacer()
                        }
                        
                    }
                }
                .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.2)
                .background(.yellow)
                
                if smartBatteryViewModel.isAdapterConnected {
                    HStack {
                        if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                            if isAdapterAnimated {
                                VStack {

                                    CustomImage(systemName: "battery_adapter", isSystemName: false)
                                    CustomContent(content: adapterInfo.Name)
                                }
                                .frame(width: geo.size.width * 0.2)
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
                                .foregroundColor(ThemeColor.lightGray.color)
                                
                                VStack(spacing: 0) {
                                    Spacer()
                                    InfoElipseHImageView(title: "제조사", content: "\(adapterInfo.Manufacturer)")
                                    Spacer()
                                    InfoElipseHImageView(title: "와츠", content: "\(adapterInfo.Watts)")
                                    Spacer()
                                    InfoElipseHImageView(title: "하드웨어버전", content: "\(adapterInfo.HwVersion)")
                                    Spacer()
                                }
                                .frame(width: geo.size.width * 0.375)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                }
                                .foregroundColor(ThemeColor.lightGray.color)
                                Spacer()
                            }
                        }
                    }
                    .frame(width:geo.size.width * 0.97, height: geo.size.height * 0.4)
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
                            VStack(spacing: 0) {
                                Spacer()
                                //TODO: 로딩 뷰 추가
                                InfoRectangleHImageTextView(imageName: "thermometer.medium",isSystem:true, title: "계산중..", info: "",widthScale:0.2, heightScale:0.5)
                                Spacer()
                            }
                        }
                        .frame(width:geo.size.width * 0.94, height: geo.size.height * 0.4)
                    }
                    else {
                        HStack(alignment:.center ,spacing:0){

                            VStack(alignment: .center) {
                                WGifView(gifName: "battery_adapter_plugin_animation", imageSize: CGSize(width: 50, height: 50))
                                Spacer(minLength: 10)
                                Text("어댑터를 꽃으면 정보가 나와요!")
                                    .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                                    .shadow(radius: 5)
                                    
                            }.frame(width: geo.size.width * 0.46)
                            
                            VStack(spacing: 0) {
                                InfoRectangleHImageTextView(imageName: "battery_status",isSystem: false, title: "배터리 상태", info: smartBatteryViewModel.healthState == "" ? "계산중.." : smartBatteryViewModel.healthState,widthScale:0.2, heightScale:0.5)
                                    .frame(height:geo.size.height * 0.2)
                                InfoRectangleHImageTextView(imageName: "battery_cell",isSystem: false, title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)",widthScale:0.2, heightScale:0.5)
                                    .frame(height:geo.size.height * 0.2)
                            }
                            .frame(width: geo.size.width * 0.46)
                        }
                        .frame(width:geo.size.width * 0.95, height: geo.size.height * 0.4)
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
                
                BatteryBarView(batteryLevel: smartBatteryViewModel.currentBatteryCapacity == 0.0 ? 1.0 : smartBatteryViewModel.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.isAdapterConnected)
                    .frame(width: geo.size.width * 0.95, height: 50)
                HStack(spacing: 30) {
                    InfoRectangleHImageTextView(imageName: "battery_recycle",isSystem: false, title: "사이클 수", info: smartBatteryViewModel.cycleCount.toBun(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_thermometer", isSystem: false, title: "온도", info: smartBatteryViewModel.temperature.toDegree(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_currentCapa", isSystem: false, title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "battery_designdCapa", isSystem: false, title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                }.frame(width: geo.size.width * 0.95)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(CategoryType.smartBattery.title)
            .padding(.top, 40)
            .toastView(toast: $toast)
        }
    }
    
}

extension SmartBatteryView {
    private func getBatteryImageName() -> String {
        if smartBatteryViewModel.isAdapterConnected {
            if smartBatteryViewModel.currentBatteryCapacity == 1 {
                return "battery_full.charge"
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

struct SmartBatteryView_Previews: PreviewProvider {
    static var previews: some View {
        SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService())).frame(width: 1500,height:1000)
    }
}





