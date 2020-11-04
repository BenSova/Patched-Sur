//
//  MainView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct MainView : View {
    @State var buttonBG = Color.accentColor
    @State var status = "Start"
    @Binding var p: Int
    
    var body: some View {
        VStack {
            Text("Welcome to Patched Sur!").bold()
            Text("Patched Sur is a simple, easy to use patcher for macOS Big Sur on your unsupported Mac. It sets up the ideal environment for Big Sur and makes sure all your favorite services, like iCloud, still work.")
                .padding()
                .multilineTextAlignment(.center)
            Button {
                status = "Loading..."
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    if status == "Loading..." {
                        Text("Loading...")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 50)
                            .onAppear() {
                                p = 1
                            }
                    } else {
                        Text("Start")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 50)
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            Text("\(AppInfo.version) (\(AppInfo.build))")
                .font(.caption)
        }
    }
}
