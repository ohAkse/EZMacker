//
//  InfoWifiMainView.swift
//  EZMacker
//
//  Created by 박유경 on 6/2/24.
//

import SwiftUI

struct InfoWifiMainInfoView: View {
    @Binding var ssid: String
    @Binding var wifiLists: [ScaningWifiData]
    @State var isLoading = true
    @EnvironmentObject var colorScheme: ColorSchemeViewModel
    var onRefresh: () -> Void?
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "wifi.router.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    
                    Text("\(ssid)")
                        .customNormalTextFont(fontSize: FontSizeType.large.size, isBold: true)
                    Spacer()
                    
                }
                .frame(width: 200, height: 300)
                .padding(40)
                Spacer()
                if wifiLists.isEmpty == true {
                    HStack(alignment:.center) {
                        ProgressView("Loading Wi-Fi Networks...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width:300, height:300)
                    }
                    Spacer()
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                             Spacer()
                             Button(action: {
                                 onRefresh()
                             }) {
                                 Image(systemName: "rays")
                                     .resizable()
                                     .frame(width: 15, height: 15)
                                     .background(Color.clear)
                                     .clipShape(Circle())
                             }
                         }
                        .padding([.trailing], 20)
                        
                        List {
                            ForEach(wifiLists) { wifi in
                                HStack {
                                    Image(systemName: "wifi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text(wifi.ssid)
                                        .font(.headline)
                                    Spacer()
                                    Text("RSSI: \(wifi.rssi)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .listRowInsets(EdgeInsets())
                        .customBackgroundColor()
                        .padding()
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .customBackgroundColor()
        .clipped()
    }
}


#if DEBUG
struct InfoWifiMainInfoView_Preview: PreviewProvider {
    static var colorScheme = ColorSchemeViewModel()

    @State static var ssid = "ABCD"
    @State static var wifiLists = [
        ScaningWifiData(ssid: "Network 1", rssi: "-70"),
        ScaningWifiData(ssid: "Network 2", rssi: "-60"),
        ScaningWifiData(ssid: "Network 3", rssi: "-80")
    ]
    static var previews: some View {
        InfoWifiMainInfoView(ssid: $ssid, wifiLists: $wifiLists, onRefresh: {})
            .environmentObject(colorScheme)
    }
}
#endif
