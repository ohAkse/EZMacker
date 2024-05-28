import SwiftUI

struct InfoArcIndicatorView: View {
    @Binding var wifiStrength: Int
    @State var wifiPower: String = ""
    var body: some View {
        VStack {
            ZStack {
                ArcShape(percentage: 1.0)
                    .stroke(
                        Color.gray.opacity(0.2),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )

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
                
                VStack(alignment:.center, spacing: 0) {
                    Text("\(getWifiStrength())")
                        .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                    Spacer()
                    Text("\(wifiStrength)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .offset(y: 50)
            }
            .padding()
            
            HStack {
                Text("-100")
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer()
                Text("0")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .offset(x: -10)
            }
        }
    }
    private func getWifiStrength()-> String {
        let description: String
        switch wifiStrength {
        case -30..<0:
            description = "매우 강한 신호"
        case -50..<(-30):
            description = "강한 신호"
        case -70..<(-50):
            description = "양호한 신호"
        case -80..<(-70):
            description = "약한 신호"
        case ..<(-80):
            description = "매우 약한 신호"
        default:
            description = "알 수 없는 신호 강도"
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

#if DEBUG
struct InfoArcIndicatorView_Preview: PreviewProvider {
    @State static var wifiStrength: Int = -71
    static var previews: some View {
        InfoArcIndicatorView(wifiStrength: $wifiStrength)
    }
}
#endif
