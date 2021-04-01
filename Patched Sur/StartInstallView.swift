//
//  StartInstallView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 12/8/20.
//

import SwiftUI
import Files

struct StartInstallView: View {
    @Binding var password: String
    @State var errorT = ""
    @State var buttonBG = Color.red
    @Binding var installerPath: String
    @State var currentText = ""
    var body: some View {
        VStack {
            Text("Ready to Update!")
                .bold()
            Text("Now, Patched Sur will finish preparing for the update and restart into the macOS Updater. After a while, macOS will be finished installing and you can patch the kexts and then enjoy macOS. This will take a while! Just like the preparing for update part of system preferences, this isn't the fastest thing in the world.")
                .padding()
                .multilineTextAlignment(.center)
            if errorT == "" {
                VStack {
                    ZStack {
                        Color.secondary
                            .cornerRadius(10)
                            .frame(minWidth: 200, maxWidth: 450)
                            .onAppear(perform: {
                                DispatchQueue.global(qos: .background).async {
                                    do {
                                        let handle: (String) -> () = {
                                            if currentText.hasPrefix("""
                                                
                                                Preparing:
                                                """) {
                                                currentText.removeFirst("""
                                                
                                                Preparing:
                                                """.count)
                                            }
                                            currentText = $0 != "Password:" ? $0 : "Starting OS Installer"
                                        }
                                        if !installerPath.hasSuffix("app") {
                                            scheduleNotification(title: "macOS Update Starting Soon", body: "macOS and the kexts finished downloading, and the updater is getting ready to start. Make sure to save your work, since it could start anytime soon.")
                                            currentText = "Cleaning up before extraction"
                                            print("Clean up before extraction...")
                                            if (try? call("[[ -d /Applications/Install\\ macOS\\ Big\\ Sur.app ]]")) != nil || (try? call("[[ -d /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app ]]")) != nil {
                                                if (try? call("mkdir /Applications/Backup-Installers", p: password)) != nil {
                                                    _ = try? call("echo 'This folder was created by Patched Sur to protect your existing macOS installers while the patcher runs.' > /Applications/Backup-Installers/README.txt")
                                                    _ = try? call("mv /Applications/Install\\ macOS\\ Big\\ Sur*.app /Applications/Backup-Installers/", p: password)
                                                }
                                            }
                                            _ = try? call("rm -rf ~/.patched-sur/pkg-extract", p: password)
                                            currentText = "Unpacking package"
                                            print("Unpacking package...")
                                            try call("installer -pkg ~/.patched-sur/InstallAssistant.pkg -target /", p: password)
//                                            if installerPath == "~/.patched-sur/InstallAssistant.pkg" {
//                                                try call("cd ~/.patched-sur && pkgutil --expand-full ~/.patched-sur/InstallAssistant.pkg ~/.patched-sur/pkg-extract", h: handle)
//                                            } else {
//                                                try call("cd ~/.patched-sur && pkgutil --expand-full '\(installerPath)' ~/.patched-sur/pkg-extract", h: handle)
//                                            }
//                                            currentText = "Organizing package"
//                                            print("Organizing package...")
//                                            try call("mv ~/.patched-sur/pkg-extract/Payload/Applications/Install\\ macOS\\ Big\\ Sur*.app ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app")
//                                            try call("mkdir ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport")
//                                            try call("ln -fFh ~/.patched-sur/pkg-extract/SharedSupport.dmg ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport", p: password)
//                                            try call("/bin/chmod 0644 ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport/SharedSupport.dmg", p: password)
//                                            try call("/usr/sbin/chown -R root:wheel ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport/SharedSupport.dmg", p: password)
//                                            try call("/usr/bin/chflags -h norestricted ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport/SharedSupport.dmg", p: password)
//                                            _ = try? call("rm -rf ~/.patched-sur/pkg-extract", p: password)
                                            currentText = "Starting OS Installer"
                                            print("Starting OS Installer....")
                                            try call("/Applications/Install\\ macOS\\ Big\\ Sur*.app/Contents/Resources/startosinstall --volume / --nointeraction", p: password, h: handle)
//                                            try call("[[ -e /Applications/Install\\ macOS\\ Big\\ Sur.app/Contents/Resources/startosinstall ]]")
                                        } else {
                                            currentText = "Starting OS Installer"
                                            print("Starting OS Installer...")
                                            try call("'\(installerPath)/Contents/Resources/startosinstall' --volume / --nointeraction", p: password, h: handle)
//                                            try call("[[ -e '\(installerPath)/Contents/Resources/startosinstall' ]]")
                                        }
                                    } catch {
                                        errorT = error.localizedDescription
                                    }
                                }
                            })
                        Text("Preparing for Update...")
                            .foregroundColor(.white)
                            .lineLimit(4)
                            .padding(6)
                            .padding(.horizontal, 4)
                    }.fixedSize()
                    Text(currentText)
                        .font(.caption)
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
//            } else if !correctPassword {
//                EnterPasswordButton(password: $password) {
//                    correctPassword = true
//                }
            } else {
                VStack {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(errorT, forType: .string)
                    } label: {
                        ZStack {
                            buttonBG
                                .cornerRadius(10)
                                .onHover(perform: { hovering in
                                    buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                })
                                .onAppear(perform: {
                                    if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                        buttonBG = .red
                                    }
                                })
                            Text(errorT)
                                .foregroundColor(.white)
                                .lineLimit(4)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }.frame(minWidth: 200, maxWidth: 450)
                    }.buttonStyle(BorderlessButtonStyle())
                    Text("Click to Copy")
                        .font(.caption)
                }.fixedSize()
            }
        }.frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
    }
}
