import SwiftUI

struct SmartBatteryView: View {
    //ObservedObject는 갱신하면 파괴후 다시 생성하면서 타이머 돌린게 바로 업데이트 안됨
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel
    @State private var toast: Toast?
    @State private var isAnimated = false
    @State private var isAdapterAnimated = true
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        if smartBatteryViewModel.currentBatteryCapacity == 100 {
                            VStack(alignment:.leading, spacing: 0) {
                                HStack(spacing:0) {
                                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "충전 완료! ", info: "", widthScale:0.3, heightScale:0.7)
                                }
                                .frame(height:geo.size.height * 0.2)
                            }.frame(width: geo.size.width * 0.2, height:geo.size.height * 0.2)
                        } else {
                            if smartBatteryViewModel.isCharging {
                                VStack(alignment:.leading, spacing: 0) {
                                    HStack(spacing:0) {
                                        InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "완충까지 ", info: smartBatteryViewModel.chargingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                    }.frame(height:geo.size.height * 0.2)
                                }.frame(width: geo.size.width * 0.2, height:geo.size.height * 0.2)
                            } else {
                                VStack(alignment:.leading, spacing: 0) {
                                    HStack {
                                        InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "종료까지", info: smartBatteryViewModel.remainingTime.toHourMinute(), widthScale:0.3, heightScale:0.7)
                                    }.frame(height:geo.size.height * 0.2)
                                }.frame(width: geo.size.width * 0.2, height:geo.size.height * 0.15)
                            }
                        }
                        
                        Spacer()
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top, spacing: 5) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .background(Color.clear)
                                Text("계산까지 약 1분 소요")
                                    .customText(fontSize: FontSizeType.small.size, isBold: true)
                                    .frame(minWidth: 100, maxWidth: 250)
                                    .padding(.top, 5)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .padding(.top, 5)
                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.2)
                    }
                }
                .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.2)
                .background(.yellow)
                //TODO: 로직 추가할것
                
                if !smartBatteryViewModel.isAdapterConnected {
                    HStack {
                        if isAdapterAnimated {
                            VStack {
                                Image(systemName: "globe")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(Color.red, Color.blue)
                                    .background(Color.clear)
                            }.frame(width: geo.size.width * 0.2)
                        }
                        
                        VStack(spacing:0){
                            Spacer()
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                            }
                            Spacer()
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                            }
                            Spacer()
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                            }
                            Spacer()
                        }
                        .frame(width: geo.size.width * 0.37)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                            
                        }
                        .foregroundColor(ThemeColor.lightGray.color)
                        
                        VStack(spacing: 0) {
                            Spacer()
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                                
                            }
                            Spacer()
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                            }
                            Spacer()
                            
                            if isAdapterAnimated {
                                HStack {
                                    Text("어댑터명:")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                    
                                    Text("어댑터명")
                                        .font(.system(size: 30))
                                        .foregroundStyle(ThemeColor.lightBlack.color)
                                }
                            }
                            Spacer()
                        }
                        .frame(width: geo.size.width * 0.37)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                        }
                        .foregroundColor(ThemeColor.lightGray.color)
                        
                        Spacer()
                    }
                    .frame(width:geo.size.width * 0.95)
//                    .onAppear{
//                        withAnimation(.default) {
//                            isAdapterAnimated.toggle()
//                        }
//                    }
//                    .onDisappear {
//                        withAnimation(.default) {
//                            isAdapterAnimated.toggle()
//                        }
//                    }
                } else {
                    HStack(alignment:.center ,spacing:0){
                        VStack(spacing: 0) {
                            Spacer()
                            InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "어댑터를 꽂으면 정보가 나와요", info: "",widthScale:0.2, heightScale:1)
                                .frame(height:geo.size.height * 0.4)
                            Spacer()
                        }.frame(width: geo.size.width * 0.47)
                            .padding(.trailing, 20)
                        
                        VStack(spacing: 0) {
                            InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "배터리", info: smartBatteryViewModel.healthState,widthScale:0.2, heightScale:0.5)
                                .frame(height:geo.size.height * 0.2)
                            InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "베터리셀 끊김 횟수", info: "\(smartBatteryViewModel.batteryCellDisconnectCount)",widthScale:0.2, heightScale:0.5)
                                .frame(height:geo.size.height * 0.2)
                        }
                        .frame(width: geo.size.width * 0.46)
                    }
                    .frame(width:geo.size.width * 0.95)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 5)) {
                            isAnimated.toggle()
                        }
                    }
                    .onDisappear {
                        withAnimation(.easeInOut(duration: 5)){
                            isAnimated.toggle()
                        }
                    }
                }
                
                
                BatteryView(batteryLevel: smartBatteryViewModel.currentBatteryCapacity)
                    .frame(width: geo.size.width * 0.95, height: 50)
                HStack(spacing: 30) {
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "사이클 수", info: "\(smartBatteryViewModel.cycleCount)",widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "온도", info: smartBatteryViewModel.temperature.toDegree(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH(),widthScale:0.2, heightScale:1)
                        .frame(height:geo.size.height * 0.2)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH(),widthScale:0.2, heightScale:1)
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
