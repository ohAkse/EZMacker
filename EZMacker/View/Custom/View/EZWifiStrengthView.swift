//
//  EZWifiStrengthView.swift
//  EZMacker
//
//  Created by 박유경 on 8/17/24.
//

import SwiftUI

struct EZWifiStrengthView: View {
    @Binding var wifiStrength: Int
    @State var wifiPower: String = ""
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "wifi")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("신호 세기")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding([.leading, .top], 10)
                ZStack(alignment: .center) {
                    ArcShape(percentage: 1.0)
                        .stroke(
                            Color.gray.opacity(0.2),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .aspectRatio(5 / 2.5, contentMode: .fit)
                        .padding(20)
                    
                    ArcShape(percentage: getFillPercentage())
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.orange, .green]),
                                center: .center,
                                startAngle: .degrees(-180),
                                endAngle: .degrees(0)
                            ),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .aspectRatio(5 / 2.5, contentMode: .fit)
                        .padding(20)
                    VStack {
                        Text("\(getWifiStrength())")
                            .ezNormalTextStyle(fontSize: FontSizeType.large.size, isBold: true)
                        Spacer(minLength: 5)
                        Text("\(wifiStrength)dBm")
                            .ezNormalTextStyle(fontSize: FontSizeType.medium.size, isBold: true)
                            .fontWeight(.bold)
                        Spacer(minLength: 5)
                    
                    }
                    .frame(height: geo.size.height * 0.01, alignment: .top)
                }
                .padding([.leading, .trailing], 15)
                Spacer(minLength: 5)
            }
            .ezBackgroundColorStyle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    private func getWifiStrength() -> String {
        let description: String
        switch wifiStrength {
        case 0:
            description = "--"
        case -30..<0:
            description = "최상"
        case -50..<(-30):
            description = "좋음"
        case -70..<(-50):
            description = "중간"
        case -80..<(-70):
            description = "약함"
        case ..<(-80):
            description = "매우 약함"
        default:
            description = "계산중.."
        }
        return description
    }

    private func getFillPercentage() -> Double {
        return min(max(Double(wifiStrength + 100) / 100.0, 0.0), 1.0)
    }
}

struct ArcShape: Shape {
    var percentage: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startAngle = Angle(degrees: 180)
        let endAngle = Angle(degrees: 180 + (180 * percentage))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        return path
    }
}

// #if DEBUG
// struct InfoArcIndicatorView_Preview: PreviewProvider {
//    @State static var wifiStrength: Int = -71
//    static var previews: some View {
//        InfoArcIndicatorView(wifiStrength: $wifiStrength)
//
//    }
// }
// #endif
