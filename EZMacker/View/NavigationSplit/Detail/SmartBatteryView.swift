import SwiftUI

struct SmartBatteryView: View {
    //ObservedObject는 갱신하면 파괴후 다시 생성하면서 타이머 돌린게 바로 업데이트 안됨
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel
    @State private var toast: Toast?
    @State private var isAdapterAnimated = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        VStack(alignment:.leading, spacing:0) {
                            if smartBatteryViewModel.currentBatteryCapacity == 100 {
                                InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "충전 완료! ", info: "", widthScale:0.3, heightScale:0.7)
                            } else {
                                if smartBatteryViewModel.isCharging {
                                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "완충까지 ", info: smartBatteryViewModel.chargingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                } else  {
                                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "종료까지", info: smartBatteryViewModel.remainingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                }
                            }
                            
                        }
                        .frame(width: geo.size.width * 0.2, height:geo.size.height * 0.2)
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
                        if isAdapterAnimated {
                            VStack {
                                CustomImage(systemName: "battery_adapter", isSystemName: false)
                                if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                                    CustomContent(content: adapterInfo.Name)
                                }
                                
                            }
                            .frame(width: geo.size.width * 0.2)
                            .padding(.bottom, 5)
                            VStack(spacing:0){
                                Spacer()
                                if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                                    InfoElipseHImageView(title: "AdapterID", content: "\(adapterInfo.AdapterID)")
                                    Spacer()
                                    InfoElipseHImageView(title: "Model ID", content: "\(adapterInfo.Model)")
                                    Spacer()
                                    InfoElipseHImageView(title: "FwVersion", content: "\(adapterInfo.FwVersion)")
                                    Spacer()
                                }
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                            }
                            .foregroundColor(ThemeColor.lightGray.color)
                            
                            VStack(spacing: 0) {
                                Spacer()
                                if let adapterInfo = smartBatteryViewModel.adapterInfo?.first {
                                    InfoElipseHImageView(title: "Manufacturer", content: "\(adapterInfo.Manufacturer)")
                                    Spacer()
                                    InfoElipseHImageView(title: "Watts", content: "\(adapterInfo.Watts)")
                                    Spacer()
                                    InfoElipseHImageView(title: "HwVersion", content: "\(adapterInfo.HwVersion)")
                                    Spacer()
                                }
                            }
                            .frame(width: geo.size.width * 0.37)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                            }
                            .foregroundColor(ThemeColor.lightGray.color)
                            Spacer()
                        }
                    }
                    .frame(width:geo.size.width * 0.95)
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
                    
                } else {
                    HStack(alignment:.center ,spacing:0){
                        VStack(spacing: 0) {
                            Spacer()
                            InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "어댑터를 꽂으면 정보가 나와요", info: "",widthScale:0.2, heightScale:1)
                                .frame(height:geo.size.height * 0.4)
                            Spacer()
                        }.frame(width: geo.size.width * 0.47)
                            .padding(.trailing, 20)
                        
                        VStack(spacing: 0) {
                            InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "배터리", info: smartBatteryViewModel.healthState == "" ? "계산중.." : smartBatteryViewModel.healthState,widthScale:0.2, heightScale:0.5)
                                .frame(height:geo.size.height * 0.2)
                            InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)",widthScale:0.2, heightScale:0.5)
                                .frame(height:geo.size.height * 0.2)
                        }
                        .frame(width: geo.size.width * 0.46)
                    }
                    .frame(width:geo.size.width * 0.95)
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
                BatteryBarView(batteryLevel: smartBatteryViewModel.currentBatteryCapacity == 0.0 ? 1.0 : smartBatteryViewModel.currentBatteryCapacity, isAdapterConnected: $smartBatteryViewModel.isAdapterConnected)
                    .frame(width: geo.size.width * 0.95, height: 50)
                HStack(spacing: 30) {
                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "사이클 수", info: smartBatteryViewModel.cycleCount.toBun(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "온도", info: smartBatteryViewModel.temperature.toDegree(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleHImageTextView(imageName: "thermometer.medium", title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                }.frame(width: geo.size.width * 0.95)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(CategoryType.smartBattery.title)
            .padding(0)
            .toastView(toast: $toast)
        }
    }
}

struct SmartBatteryView_Previews: PreviewProvider {
    static var previews: some View {
        SmartBatteryView(smartBatteryViewModel: SmartBatteryViewModel(appSmartBatteryService: AppSmartBatteryService())).frame(width: 1500,height:1000)
    }
}


