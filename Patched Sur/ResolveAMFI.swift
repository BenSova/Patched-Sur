//
//  ResolveAMFI.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/11/21.
//

import SwiftUI

struct ResolveAMFI: View {
    @Binding var at: Int
    @State var progress = 0
    @State var hovered: String?
    @State var password = ""
    @State var lvError = ""
    @State var buttonBG = Color.accentColor
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("AMFI Detected to Be Off")
                        .padding(.horizontal, 4)
                    Image(systemName: "exclamationmark.triangle")
                }
                .font(Font.body.bold())
                (Text("Wait, wasn't it Patched Sur that told me to turn it off? Yes actually, but after further looking, there's actually a problem with that. ") + Text("Don't worry, Patched Sur has been updated to handle this, and run the macOS updater with AMFI on. ").bold() + Text("Disabling AMFI prevents you from granting new app's permissions, like camera or microphone. Patched Sur now disables Library Validation in place of AMFI since it should have the same affect that Patched Sur needed to run the macOS updater. Click Resolve below to reenable AMFI."))
                    .multilineTextAlignment(.center)
                    .padding()
                if progress == 0 {
                    DoubleButtonView(first: {
                        at = 0
                    }, second: {
                        progress = 1
                    }, text: "Resolve")
                } else if progress == 1 {
                    EnterPasswordButton(password: $password) {
                        do {
                            print("Disabling Library Validation...")
                            try call("defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true", p: password)
                        } catch {
                            lvError = error.localizedDescription
                            print("Failed to disable Library Validation, but it's more important to disable AMFI, so doing that...")
                            progress = -1
                            return
                        }
                        do {
                            print("Disabling AMFI...")
                            try call("nvram boot-args=\"-no_compat_check\"", p: password)
                        } catch {
                            print("Failed to update NVRAM, warning user.")
                            lvError = error.localizedDescription
                            progress = -2
                            return
                        }
                        if lvError != "" {
                            progress = -1
                        } else {
                            progress = 2
                        }
                    }
                } else if progress == -1 {
                    VStack {
                        Text("Failed to Disable Library Validation")
                            .font(.caption)
                        Button {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(lvError, forType: .string)
                        } label: {
                            ZStack {
                                buttonBG
                                    .cornerRadius(10)
                                    .frame(minWidth: 200, maxWidth: 450)
                                    .onHover(perform: { hovering in
                                        buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                    })
                                    .onAppear(perform: {
                                        if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                            buttonBG = .red
                                        }
                                    })
                                Text(lvError)
                                    .foregroundColor(.white)
                                    .lineLimit(6)
                                    .padding(6)
                                    .padding(.horizontal, 4)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        .fixedSize()
                        .frame(minWidth: 200, maxWidth: 450)
                        Text("This is fine. AMFI was the concern.")
                            .font(.caption)
                    }
                } else if progress == -2 {
                    VStack {
                        Text("Failed to Disable AMFI")
                            .font(.caption)
                        Button {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(lvError, forType: .string)
                        } label: {
                            ZStack {
                                buttonBG
                                    .cornerRadius(10)
                                    .frame(minWidth: 200, maxWidth: 450)
                                    .onHover(perform: { hovering in
                                        buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                    })
                                    .onAppear(perform: {
                                        if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                            buttonBG = .red
                                        }
                                    })
                                Text(lvError)
                                    .foregroundColor(.white)
                                    .lineLimit(6)
                                    .padding(6)
                                    .padding(.horizontal, 4)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        .fixedSize()
                        .frame(minWidth: 200, maxWidth: 450)
                        HStack {
                            Text("Click to Copy")
                            Link(destination: "https://bensova.gitbook.io/big-sur/postinstall-after-upgrade/amfi-problems") {
                                Text("Learn How To Fix This")
                            }
                        }
                            .font(.caption)
                    }
                } else {
                    ZStack {
                        buttonBG
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                            })
                        Text("Restart to Finish")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 50)
                    }.fixedSize()
                }
            }
        }
    }
}
