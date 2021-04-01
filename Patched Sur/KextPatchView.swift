//
//  KextPatchView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/29/20.
//

import SwiftUI

struct KextPatchView: View {
    @State var unpatch = ""
    @Binding var at: Int
    var body: AnyView {
        AnyView(VStack {
            TopKextsView(unpatch: $unpatch)
            ButtonsView(at: $at, unpatch: $unpatch)
        }.navigationTitle("Patched Sur"))
    }
}

struct ButtonsView: View {
    @Binding var at: Int
    @State var p = 0
    @State var password = ""
    @State var buttonBG = Color.accentColor
    @State var errorMessage = ""
    @State var installerName = ""
    @Binding var unpatch: String
    @State var currentText = ""
    var body: some View {
        switch p {
        case 0:
            VStack {
                DoubleButtonView(first: {
                    at = 0
                }, second: {
                    p = 1
                }, text: "Continue")
                Button {
                    unpatch = " -u"
                    p = 1
                } label: {
                    Text("Unpatch Kexts")
                        .font(.caption)
                }.buttonStyle(BorderlessButtonStyle())
            }
        case 1:
            RunActionsDisplayView(action: {
                do {
                    print("Making sure that the micropatcher is actually in the right directory.")
                    _ = try? call("mv ~/.patched-sur/big-sur-micropatcher ~/.patched-sur/big-sur-micropatcher")
                    print("Checking for USB at \"/Volumes/Install macOS Big Sur Beta\"...")
                    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta' ]]")) != nil {
                        print("Found installer at Beta path")
                        installerName = "/Volumes/Install\\ macOS\\ Big\\ Sur\\ Beta"
                        p = 2
                        return
                    }
                    print("Checking for USB at \"/Volumes/Install macOS Big Sur\"")
                    if (try? call("[[ -d '/Volumes/Install macOS Big Sur' ]]")) != nil {
                        print("Found installer at Regular path")
                        installerName = "/Volumes/Install\\ macOS\\ Big\\ Sur"
                        p = 2
                        return
                    }
                    print("Checking for kexts at \"~/.patched-sur/big-sur-micropatcher/payloads/kexts\"")
                    if (try? call("[[ -d ~/.patched-sur/big-sur-micropatcher/payloads/kexts ]]")) != nil {
                        print("Found pre-downloaded kexts!")
                        print("Making sure this is Ben's fork...")
                        if (try? call("cat ~/.patched-sur/big-sur-micropatcher/payloads/patch-kexts.sh | grep \".patched-sur/big-sur-micropatcher/payloads\"")) != nil {
                            print("This is Ben's fork of the micropatcher")
                            installerName = "~/.patched-sur/big-sur-micropatcher/payloads"
                            p = 2
                            return
                        }
                    }
                    throw ShellOutError(terminationStatus: 1, errorData: .init(), outputData: .init())
                } catch {
                    print("USB is not at either detected place or does not have patch-kexts.sh on it.")
                    print("Requesting user to plug back in the usb drive.")
                    p = -1
                }
            }, text: "Detecting Volumes")
        case -1:
            VStack {
                DoubleButtonView(first: {
                    at = 0
                }, second: {
                    p = 1
                }, text: "Plug in USB Installer and Try Again")
                Button {
                    p = 2
                } label: {
                    Text("Force Skip Check")
                        .font(.caption)
                }.buttonStyle(BorderlessButtonStyle())
            }
        case 2:
            EnterPasswordButton(password: $password) {
                p = 3
            }
        case 3:
            VStack {
                RunActionsDisplayView(action: {
                    do {
                        let patchKextsOutput = try call("\(installerName)/patch-kexts.sh", p: password, h: { currentText = $0 })
                        UserDefaults.standard.setValue(patchKextsOutput, forKey: "PatchKextsLastRun")
                        p = 4
                    } catch {
                        errorMessage = error.localizedDescription
                        UserDefaults.standard.setValue(error.localizedDescription, forKey: "PatchKextsLastRun")
                        p = -2
                    }
                }, text: "Patching Kexts...")
                Text(currentText)
                    .font(.caption)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        case -2:
            VStack {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(errorMessage, forType: .string)
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
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .lineLimit(6)
                            .padding(6)
                            .padding(.horizontal, 4)
                    }
                }.buttonStyle(BorderlessButtonStyle())
                .fixedSize()
                .frame(minWidth: 200, maxWidth: 450)
                Text("Click to Copy")
                    .font(.caption)
            }
        case 4:
            Button {
                DispatchQueue.global(qos: .background).async {
                    do {
                        try call("reboot", p: password)
                    } catch {
                        print("Error running restart, but they can do it themselves.")
                        presentAlert(m: "Failed to Reboot", i: "You can do it yourself! Cmd+Control+Eject (or Cmd+Control+Power if you want it to be faster) will reboot your computer, or you can use the Apple logo in the corner of the screen. Your choice, they all work.")
                    }
                }
            } label: {
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
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        default:
            Text("Something went wrong. This number is out of range.\nError 0x\(p)")
        }
    }
}

struct TopKextsView: View {
    @Binding var unpatch: String
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text(unpatch == "" ? "Patch Kexts" : "Unpatch Kexts").bold()
                Spacer()
            }
        }
        Text("Patching your kexts gets you Wifi, USB, and many other things working on your Big Sur installation. Without these kexts, your Mac would not be at its full potential on Big Sur, and several things would not work. Makes sense right?")
            .padding()
            .multilineTextAlignment(.center)
    }
}
