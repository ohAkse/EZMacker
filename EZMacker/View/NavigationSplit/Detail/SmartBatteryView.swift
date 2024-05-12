import SwiftUI

struct SmartBatteryView: View {
    //ObservedObject는 갱신하면 파괴후 다시 생성하면서 타이머 돌린게 바로 업데이트 안됨
    @StateObject var smartBatteryViewModel: SmartBatteryViewModel
    @State private var toast: Toast?
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        if smartBatteryViewModel.currentBatteryCapacity == 100 {
                            VStack(alignment:.leading, spacing: 0) {
                                HStack(spacing:0) {
                                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "충전 완료! ", info: "", widthScale:0.3, heightScale:0.7)
                                }.frame(height:geo.size.height * 0.2)
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
                
                HStack(spacing: 20){
                    HStack {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: geo.size.width * 0.47, height: geo.size.height * 0.4)
                            .background(Color.red)
                            .onTapGesture {
                                toast = Toast(type: .success, title: "테스트", message: "테스트 메시지 입니다")
                            }
                    }
                    
                    VStack(spacing: 0) {
                        InfoRectangleTextView(header: "배터리 상태", content: smartBatteryViewModel.healthState)
                            .frame(height: geo.size.height * 0.21)
                        Spacer()
                        InfoRectangleTextView(header: "베터리셀 끊김 횟수", content: "\(smartBatteryViewModel.batteryCellDisconnectCount)")
                            .frame(height: geo.size.height * 0.21)
                    }.frame(width: geo.size.width * 0.46)
                }
                
                BatteryView(batteryLevel: smartBatteryViewModel.currentBatteryCapacity)
                    .frame(width: geo.size.width * 0.95, height: 50)
                HStack(spacing: 30) {
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "사이클 수", info: "\(smartBatteryViewModel.cycleCount)",widthScale:0.2, heightScale:1)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "온도", info: smartBatteryViewModel.temperature.toDegree(),widthScale:0.2, heightScale:1)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "배터리 용량", info: smartBatteryViewModel.batteryMaxCapacity.tomAH(),widthScale:0.2, heightScale:1)
                    InfoRectangleImageWithTextView(imageName: "thermometer.medium", title: "설계 용량", info: smartBatteryViewModel.designedCapacity.tomAH(),widthScale:0.2, heightScale:1)
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
