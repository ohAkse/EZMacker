//
//  AlertInfoView.swift
//  EZMacker
//
//  Created by 박유경 on 6/15/24.
//

import SwiftUI

struct AlertOKCancleView: View {
    @Binding var isPresented: Bool
    var title: String
    var subtitle: String
    var content: String
    var onOk: (() -> Void)? = nil
    
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
            Text(content)
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
                    onOk?()
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
