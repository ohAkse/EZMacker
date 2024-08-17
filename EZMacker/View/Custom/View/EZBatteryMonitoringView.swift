//
//  EZGridMonitoringView.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import SwiftUI

struct EZBatteryMonitoringView: View {
    @Binding var chargeData: [ChargeData]
    @Binding var isAdapterConnect: Bool
    var body: some View {
        GeometryReader { geometry in
            HStack{
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
                        if isAdapterConnect {
                            if let lastChargeData = chargeData.last, lastChargeData.notChargingReason != 0 {
                                Text("No Charging: \(lastChargeData.notChargingReason.toNumber())")
                                    .foregroundColor(Color.gray)
                                    .ezNormalTextStyle(fontSize: FontSizeType.medium.size, isBold: true)
                                    .padding()
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            } else {
                                Text("")
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

