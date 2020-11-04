//
//  InstallModeView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/17/20.
//

import SwiftUI

struct InstallMethodView: View {
    @Binding var method: InstallMethod
    @State var buttonBG = Color.accentColor
    @Binding var p: Int
    @State var hovered = nil as InstallMethod?
    var body: some View {
        VStack {
            Text("Clean Install or Update macOS").bold()
            Text("Here, you can choose whether you want to update your macOS version from Catalina to Big Sur. Right now, Patched Sur only supports updating, but clean install support is coming soon.")
                .padding()
                .multilineTextAlignment(.center)
            HStack {
                Button {
                    method = .update
                } label: {
                    if method == .update {
                        Text("Update")
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    } else {
                        Text("Update")
                            .padding(8)
                            .background(hovered == .update ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                if hovering {
                                    hovered = .update
                                } else {
                                    if hovered == .update {
                                        hovered = nil
                                    }
                                }
                            })
                    }
                }.buttonStyle(BorderlessButtonStyle())
                Button {
                    method = .clean
                } label: {
                    if method == .clean {
                        Text("Clean")
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    } else {
                        Text("Clean")
                            .padding(8)
                            .background(hovered == .clean ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                if hovering {
                                    hovered = .clean
                                } else {
                                    if hovered == .clean {
                                        hovered = nil
                                    }
                                }
                            })
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }
            Button {
                if method != .clean {
                    p = 3
                }
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            if method != .clean {
                                buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                            }
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 10)
            .opacity(method == .clean ? 0.4 : 1)
        }
    }
}

enum InstallMethod {
    case clean
    case update
}
