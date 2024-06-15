//
//  AlertModalView.swift
//  EZMacker
//
//  Created by 박유경 on 6/11/24.
//

import SwiftUI

struct AlertTextFieldView: View {
    @Binding var textFieldValue: String
    @Binding var isPresented: Bool
    var ssid: String
    var title: String
    var subtitle: String
    var onOk: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image("alert_icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            SecureField(subtitle, text: $textFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    isPresented = false
                    onOk()
                }) {
                    Text("OK")
                }
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 10)
        .frame(width: 300) 
    }
}
