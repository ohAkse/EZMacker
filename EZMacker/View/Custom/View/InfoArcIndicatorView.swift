import SwiftUI

struct InfoArcIndicatorView: View {
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    @Binding var wifiStrength: Int
    @State var wifiPower: String = ""
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:10) {
                ZStack(alignment:.center) {
                    ArcShape(percentage: 1.0)
                        .stroke(
                            Color.gray.opacity(0.2),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .aspectRatio(5 / 3, contentMode: .fit)
                    
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
                        .aspectRatio(5 / 3, contentMode: .fit)
                    VStack() {
                        Text("\(getWifiStrength())")
                            .customNormalTextFont(fontSize: FontSizeType.superLarge.size, isBold: true)
                        Spacer(minLength: 5)
                        Text("\(wifiStrength)")
                            .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: false)
                            .fontWeight(.bold)
                        Spacer(minLength: 5)
                        
                        HStack(alignment:.center, spacing: 0) {
                            Spacer(minLength: 0)
                            Text("-80")
                                .foregroundColor(.gray)
                            Spacer(minLength: 180)
                            Text("0")
                                .foregroundColor(.gray)
                            Spacer(minLength: 0)
                        }
                        .frame(minWidth: 240)
                        
                    }
                    .frame(height: geo.size.height * 0.01, alignment: .top)
                }
                .padding([.leading, .trailing], 15)
                Spacer(minLength: 5)
            }
            .customBackgroundColor()
            .frame(minWidth: 250, maxWidth: 700,  minHeight:150,  maxHeight: 200)
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
            description = "계산중"
        }
        return description
    }
    
    private func getFillPercentage() -> Double {
        return min(max(Double(wifiStrength + 100) / 100.0, 0.0), 1.0)
    }
    
    private func cardColorForTheme() -> Color {
        switch colorScheme.getColorScheme() {
        case ColorSchemeMode.Light.title:
            return ThemeColor.lightGray.color
        case ColorSchemeMode.Dark.title:
            return ThemeColor.lightBlue.color
        default:
            Logger.fatalErrorMessage("colorSchme is Empty")
            return Color.clear
        }
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

//#if DEBUG
//struct InfoArcIndicatorView_Preview: PreviewProvider {
//    @State static var wifiStrength: Int = -71
//    static var previews: some View {
//        InfoArcIndicatorView(wifiStrength: $wifiStrength)
//
//    }
//}
//#endif
