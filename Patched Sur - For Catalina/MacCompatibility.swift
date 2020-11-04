//
//  MacCompatibility.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct MacCompatibility: View {
    @Binding var p: Int
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            Text("Mac Compatibility").bold()
            Text("This Mac has not been tested and verified to work with this patcher. Most likely, your Mac should work, but currently support can not be confirmed. Continue at your own risk.")
                .padding()
                .multilineTextAlignment(.center)
            Button {
                p = 2
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 50)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
