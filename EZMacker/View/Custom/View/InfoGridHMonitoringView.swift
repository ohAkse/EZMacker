import SwiftUI



struct InfoGridHMonitoringView: View {
    @Binding var chargeData: [ChargeData]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepWidth = width / 5
                    let stepHeight = height / 5
                    for i in 0..<6 {
                        let x = stepWidth * CGFloat(i)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    
                    for i in 0..<6 {
                        let y = stepHeight * CGFloat(i)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.3))
                if !chargeData.isEmpty {
                    Path { path in
                        let maxCurrent = chargeData.map { $0.chargingVoltage }.max() ?? 1
                        let minCurrent = 0.0
                        
                        let yFactor = maxCurrent != minCurrent ? geometry.size.height / CGFloat(maxCurrent - minCurrent) : 0
                        
                        let xStep = geometry.size.width / 5
                        path.move(to: CGPoint(x: 0, y: geometry.size.height - (chargeData[0].chargingCurrent - minCurrent) * yFactor))
                        
                        for (index, point) in chargeData.enumerated() {
                            let xPosition = xStep * CGFloat(index)
                            let yPosition = geometry.size.height - (point.chargingCurrent - minCurrent) * yFactor
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                    .stroke(Color.red, lineWidth: 2)
                }
            }
        }
    }
}

//#if DEBUG
//struct InfoGridHMonitoringView_Previews: PreviewProvider {
//    @State static var previewData: [ChargeData] = [
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.7, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.8, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.9, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 4.0, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.6, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.7, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.9, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 4.1, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.8, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222),
//         ChargeData(vacVoltageLimit: 4325, chargingCurrent: 600, timeChargingThermallyLimited: 33, chargerStatus: Data(), chargingVoltage: 3.7, chargerInhibitReason: 0, chargerID: 13, notChargingReason: 222)
//     ]
//
//
//    static var previews: some View {
//        InfoGridHMonitoringView(chargeData: $previewData)
//            .padding()
//            .frame(width: 300, height: 200)
//    }
//}
//#endif
