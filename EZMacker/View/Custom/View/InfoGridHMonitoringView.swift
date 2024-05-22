//
//  InfoGridHMonitoringView.swift
//  EZMacker
//
//  Created by 박유경 on 5/23/24.
//
import SwiftUI

struct BatteryPoint: Identifiable {
    var id = UUID()
    var chargingCurrent: CGFloat
    var chargingVoltage: CGFloat
}


struct InfoGridHMonitoringView: View {
    @Binding var chargeData: [ChargeData]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepWidth = width / 10
                    let stepHeight = height / 5
                    
                    for i in 0..<11 {
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
                
                Path { path in
                    guard !chargeData.isEmpty else { return }
                    let maxVoltage = chargeData.map { $0.chargingVoltage }.max() ?? 1
                    let xFactor = geometry.size.width / CGFloat(max(chargeData.count, 1))
                    let yFactor = geometry.size.height / CGFloat(maxVoltage)
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height - CGFloat(chargeData[0].chargingVoltage) * yFactor))
                    
                    for (index, point) in chargeData.enumerated() {
                        let xPosition = CGFloat(index) * xFactor
                        let yPosition = geometry.size.height - CGFloat(point.chargingVoltage) * yFactor
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}
