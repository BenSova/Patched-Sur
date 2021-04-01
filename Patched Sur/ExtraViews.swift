//
//  ExtraViews.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/30/20.
//

import SwiftUI

struct DoubleButtonView: View {
    var first: () -> ()
    var second: () -> ()
    var text: String
    @State var buttonBG = Color.accentColor
    @State var buttonBG2 = Color.secondary
    var body: some View {
        HStack {
            Button {
                first()
            } label: {
                ZStack {
                    buttonBG2
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG2 = hovering ? Color.secondary.opacity(0.7) : Color.secondary
                        })
                    Text("Back")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            Button {
                second()
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text(text)
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 10)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }.fixedSize()
    }
}

struct RunActionsDisplayView: View {
    var action: () -> ()
    var text: String
    var body: some View {
        ZStack {
            Color.secondary
                .cornerRadius(10)
                .frame(minWidth: 200, maxWidth: 450)
            Text(text)
                .foregroundColor(.white)
                .lineLimit(4)
                .padding(6)
                .padding(.horizontal, 4)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        action()
                    }
                }
        }.fixedSize()
    }
}

struct EnterPasswordButton: View {
    @Binding var password: String
    @State var buttonBG = Color.accentColor
    var onDone: () -> ()
    var onSaveFail: () -> () = {}
    @State var invalidPassword = false
    var body: some View {
        HStack {
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(width: 300)
                    .opacity(0.7)
                SecureField("Enter password to continue...", text: $password)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(6)
                    .padding(.horizontal, 4)
                    .disabled(false)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.dark)
            }
            Button {
                if password != "" {
                    do {
                        try call("echo Hi", p: password)
                        print("Saving password to keychain, so we don't have to prompt again...")
                        guard let passwordData = password.data(using: .utf8) else {
                            print("It doesn't really matter, but the saving failed.")
                            onSaveFail()
                            return
                        }
                        let keychaintry = KeyChain.save(key: "bensova.Patched-Sur.userpass", data: passwordData)
                        if keychaintry == noErr {
                            print("Saved!")
                        } else {
                            print("It doesn't really matter, but the saving failed.")
                            onSaveFail()
                        }
                        onDone()
                    } catch {
                        invalidPassword = true
                        password = ""
                    }
                }
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            if !(password == "") {
                                if invalidPassword {
                                    buttonBG = hovering ? Color.red.opacity(0.7) : Color.red
                                } else {
                                    buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                }
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
            .opacity(password == "" ? 0.4 : 1)
        }.fixedSize()
    }
}

struct TextAndButtonView: View {
    let t: String
    let b: String
    let action: () -> ()
    @State var hovered = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.accentColor.opacity(0.3))
                .cornerRadius(10)
            HStack(spacing: 0) {
                Text(t)
                    .padding(6)
                    .padding(.leading, 4)
                Button {
                    action()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(!hovered ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                            .cornerRadius(10)
                        Text(b)
                            .padding(6)
                            .padding(.horizontal, 4)
                            .foregroundColor(.white)
                    }.fixedSize()
                }.buttonStyle(BorderlessButtonStyle())
                .onHover {
                    hovered = $0
                }
            }
        }.fixedSize()
    }
}
