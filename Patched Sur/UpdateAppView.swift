//
//  UpdateAppView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/25/20.
//

import SwiftUI
import Files

struct UpdateAppView: View {
    let latest: PatchedVersion
    @State var hovered = nil as String?
    @Binding var p: Int
    @State var downloading = false
    @State var errorMessage = ""
    @Binding var skipCheck: Bool
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var currentSize = 10
    let timer = Timer.publish(every: 0.25, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    p = -1
                } label: {
                    ZStack {
                        ZStack {
                            if downloading {
                                Color.secondary.opacity(0.7).cornerRadius(10)
                            } else {
                                hovered == "BACK-HOME" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                            }
                            Text("Back")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "BACK-HOME" : nil
                        }
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    skipCheck = true
                    p = 0
                } label: {
                    ZStack {
                        ZStack {
                            if downloading {
                                Color.secondary.opacity(0.7).cornerRadius(10)
                            } else {
                                hovered == "SKIP-UPDATE" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                            }
                            Text("Skip")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "SKIP-UPDATE" : nil
                        }
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Text("Patched Sur \(latest.name)")
//                Text("Patched Sur v0.1.0 Beta")
                    .font(.title2)
                    .bold()
                Spacer()
                if downloading {
                    ZStack {
                        ZStack(alignment: .leading) {
                            Color.accentColor.opacity(0.4).frame(width: 140)
                            Color.accentColor.frame(width: min(downloadProgress * 140, 140))
                        }.cornerRadius(10)
                        .onReceive(timer, perform: { _ in
                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/Patched-Sur.zip") {
                                currentSize = Int(Float(sizeCode) ?? 10000)
                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(latest.assets[1].size)
                            }
                        })
                        Text("Downloading Update")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 3)
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    do {
                                        print("Pre-Download Clean Up...")
                                        try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
                                        _ = try? File(path: "~/.patched-sur/Patched-Sur.zip").delete()
                                        _ = try? Folder(path: "~/.patched-sur/Patched Sur.app").delete()
                                        print("Getting download size of Patched Sur...")
                                        if let sizeString = try? call("curl -sI \(latest.assets[1].browserDownloadURL) | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
                                            downloadSize = sizeInt
                                        }
                                        print("Projected size: \(downloadSize)")
                                        print("Starting Download of updated Patched Sur...")
                                        try call("curl -L \(latest.assets[2].browserDownloadURL) -o ~/.patched-sur/Patched-Sur.zip")
//                                        try call("curl -L https://cdn.discordapp.com/attachments/781937101338837012/81689537371701250/Patched_Sur.app.zip -o ~/.patched-sur/Patched-Sur.zip")
                                        print("Unzipping download...")
                                        try call("unzip ~/.patched-sur/Patched-Sur.zip")
                                        print("Starting Patched Sur Updater...")
                                        let appOutput = try call("~/.patched-sur/Patched\\ Sur.app/Contents/MacOS/Patched\\ Sur --update")
                                        print(appOutput)
                                        print("Updater started, closing app.")
                                        NSApplication.shared.terminate(nil)
                                    } catch {
                                        print(error.localizedDescription)
                                        errorMessage = "Download Failed"
                                        downloading = false
                                    }
                                }
                            }
                    }.frame(width: 140)
                    .fixedSize()
                } else if errorMessage != "" {
                    Button {
                        downloading = true
                    } label: {
                        ZStack {
                            hovered == "DOWNLOAD-UPDATE" ? Color.red.opacity(0.7).cornerRadius(10) : Color.red.cornerRadius(10)
                            Text("Try Again")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "DOWNLOAD-UPDATE" : nil
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .fixedSize()
                } else {
                    Button {
                        downloading = true
                    } label: {
                        ZStack {
                            hovered == "DOWNLOAD-UPDATE" ? Color.accentColor.opacity(0.7).cornerRadius(10) : Color.accentColor.cornerRadius(10)
                            Text("Download Update")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "DOWNLOAD-UPDATE" : nil
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .fixedSize()
                }
            }
            ScrollView {
                Text(latest.body)
//                Text(releaseNotesThing)
            }
        }.padding(20)
        .onAppear {
            UserDefaults.standard.setValue(latest.tagName, forKey: "LastCheckedPSVersion")
        }
    }
}
//
//let releaseNotesThing = """
//Patched Sur v0.1.0 is a big update with one pretty big thing that will help make the unsupported Mac experience more like a real Mac. You can now download software updates without needing to make a new USB installer like before. There's also a way to enable update notifications, so you never miss one (unless you hated those like me). I'll add a little bit more to these notes once I have time, but I just really wanted to get this update out haha.
//
//## New Features
//- Patched Sur now has an updater for macOS inside the post-install app.
//- You can now get update notifications for both the patcher and macOS.
//- You can set the patcher to auto-update.
//- There's a patch kexts logs section in Settings.
//
//## Bug Fixes
//- Remove the close button as a cheap workaround for closing all windows when the last window is closed in the pre-install app. (@Solomon-Wood)
//- Remove beta from some parts of the README (@Monkiey)
//"""
