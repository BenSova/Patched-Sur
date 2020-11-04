//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files
import Combine

struct InstallPackageView: View {
    @State var downloadStatus = "Fetching URLs..."
    @Binding var installInfo: InstallAssistant?
    @State var downloadProgress: CGFloat = 0
    @State var buttonBG = Color.accentColor
    @State var invalidPassword = false
    @Binding var password: String
    @Binding var p: Int
    @Binding var overrideInstaller: Bool
    @Binding var track: ReleaseTrack
    @State var currentSize = 10
    @State var downloadSize = 1000
    @Binding var useCurrent: Bool
    @Binding var package: String
    @Binding var installer: String
    let timer = Timer.publish(every: 2, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Downloading Install Assistant Package").bold()
            Text("The Install Assistant is the file that contains the macOS installer used to install macOS. In our case, we can't just use the app. Later on (the next step), we need to use the createinstallmedia tool provided by this package to create an installer USB. This USB drive has to be patched, so it will let us boot into it. Simple enough, right? Note: This download will take a while.")
                .padding()
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Fetching URLs..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Fetching URLs...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .onAppear {
                            if installInfo != nil {
                                downloadStatus = "Download macOS \(installInfo!.version)"
                                return
                            } else if package != "~/.patched-sur/InstallAssistant.pkg" {
                                useCurrent = true
                                downloadStatus = "Use Pre-Downloaded Package"
                                return
                            } else if installer != "/Applications/Install macOS Big Sur Beta.app" {
                                useCurrent = true
                                downloadStatus = "Use Pre-Downloaded Installer App"
                                return
                            }
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    let allInstallInfo = try InstallAssistants(data: try Data(contentsOf: URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : "Public").json")!))
                                    installInfo = allInstallInfo.filter({ (installer) -> Bool in
                                        if installer.minVersion > AppInfo.build {
                                            return false
                                        }
                                        return true
                                    }).sorted(by: { (one, two) -> Bool in
                                        if one.orderNumber > two.orderNumber {
                                            return true
                                        }
                                        return false
                                    })[0]
                                    if (try? InstallAssistant(try File(path: "~/.patched-sur/InstallInfo.txt").readAsString()))?.version == installInfo?.version {
                                        useCurrent = true
                                        downloadStatus = "Download macOS \(installInfo!.version)"
                                        return
                                    }
                                    downloadStatus = "Download macOS \(installInfo!.version)"
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else if downloadStatus.hasPrefix("Download macOS") {
                    VStack {
                        Button {
                            if !useCurrent {
                                if let sizeString = try? shellOut(to: "curl -sI \(installInfo!.url) | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
                                    downloadSize = sizeInt
                                }
                                downloadStatus = downloadStatus.replacingOccurrences(of: "Download", with: "Downloading") + "..."
                            } else {
                                buttonBG = Color.accentColor
                                downloadStatus = ""
                            }
                        } label: {
                            ZStack {
                                buttonBG
                                    .cornerRadius(10)
                                if package == "~/.patched-sur/InstallAssistant.pkg" && installer == "/Applications/Install macOS Big Sur.app" {
                                    Text("\(useCurrent ? "Use" : "Download") macOS \(installInfo!.version)")
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .padding(.horizontal, 4)
                                } else if package != "~/.patched-sur/InstallAssistant.pkg" {
                                    Text("Use Pre-Downloaded InstallAssistant")
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .padding(.horizontal, 4)
                                } else {
                                    Text("Use Pre-Downloaded Installer App")
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .onHover { (hovering) in
                                if useCurrent || package != "~/.patched-sur/InstallAssistant.pkg" {
                                    buttonBG = hovering ? Color.green.opacity(0.7) : Color.green
                                } else {
                                    buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                }
                            }
                            .onAppear {
                                buttonBG = useCurrent ? Color.green : Color.accentColor
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        Button {
                            p = 11
                        } label: {
                            Text("View Other Versions")
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                } else if downloadStatus.hasPrefix("Downloading macOS ") {
                    VStack {
                        ZStack {
                            ProgressBar(value: $downloadProgress)
                                .onReceive(timer, perform: { _ in
                                    DispatchQueue.global(qos: .background).async {
                                        if let sizeCode = try? shellOut(to: "stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                                            currentSize = Int(Float(sizeCode) ?? 10000)
                                            downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                                        }
                                    }
                                })
                            Text(downloadStatus)
                                .foregroundColor(.white)
                                .lineLimit(5)
                                .padding(6)
                                .padding(.horizontal, 4)
                                .onAppear {
                                    _ = try? shellOut(to: "rm ~/.patched-sur/InstallAssistant.pkg")
                                    DispatchQueue.global(qos: .background).async {
                                        do {
                                            try shellOut(to: "curl -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
                                            let versionFile = try Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallInfo.txt")
                                            try versionFile.write(installInfo!.jsonString()!, encoding: .utf8)
                                            buttonBG = .accentColor
                                            downloadStatus = ""
                                        } catch {
                                            downloadStatus = error.localizedDescription
                                        }
                                    }
                                }
                        }
                    }
                } else if downloadStatus == "" {
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
                                    try shellOut(to: "echo \"\(password)\" | sudo -S echo Hi")
                                    if installer != "/Applications/Install macOS Big Sur Beta.app" {
                                        p = 5
                                    } else {
                                        downloadStatus = "Installing Package..."
                                    }
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
                    }
                } else if downloadStatus == "Installing Package..." {
                    Color.secondary
                        .cornerRadius(10)
                    Text("Installing Package...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try shellOut(to: "echo \"\(password)\" | sudo -S installer -pkg \"\(package)\" -target /")
                                    _ = try shellOut(to: "echo \"\(track)\" > ~/.patched-sur/track.txt")
                                    p = 5
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(downloadStatus, forType: .string)
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
                            Text(downloadStatus)
                                .foregroundColor(.white)
                                .lineLimit(4)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            .fixedSize()
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(p: .constant(2))
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}

struct ProgressBar: View {
    @Binding var value: CGFloat
    var length: CGFloat = 285
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(minWidth: length)
                .opacity(0.3)
                .foregroundColor(Color(.systemTeal))
            
            Rectangle().frame(width: min(value*length, length))
                .foregroundColor(Color(.systemBlue))
                .animation(.linear)
        }.cornerRadius(10)
    }
}
