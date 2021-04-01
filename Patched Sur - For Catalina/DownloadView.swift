//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

struct DownloadView: View {
    @State var downloadStatus = "Downloading Files..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: Int
    @State var buttonBG = Color.red
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var currentSize = 10
    let timer = Timer.publish(every: 0.50, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Downloading Set Vars Tool and Kext Patches").bold()
            Text("The set vars tool allows you to properly setup the NVRAM and SIP status, so that Big Sur lets you boot into it. This is the last tool you will use before installing Big Sur. The kext patches allow you to use hardware like WiFi and USB ports, so that your Mac stays at its full functionality.")
                .padding(10)
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Downloading Files..." {
                    ProgressBar(value: $downloadProgress, length: 175)
                        .onReceive(timer, perform: { _ in
                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/big-sur-micropatcher.zip") {
                                currentSize = Int(Float(sizeCode) ?? 10000)
                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                            }
                        })
                    Text("Downloading Files...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
                                    _ = try? Folder(path: "~/.patched-sur/big-sur-micropatcher").delete()
                                    _ = try? call("rm -rf ~/.patched-sur/big-sur-micropatcher*")
                                    _ = try? File(path: "~/.patched-sur/big-sur-micropatcher.zip").delete()
                                    if let sizeString = try? shellOut(to: "curl -sI https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
                                        downloadSize = sizeInt
                                    }
                                    try call("curl -o ~/.patched-sur/big-sur-micropatcher.zip https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main")
                                    try call("unzip big-sur-micropatcher.zip", at: "~/.patched-sur")
                                    _ = try? File(path: "~/.patched-sur/big-sur-micropatcher*").delete()
                                    try call("mv ~/.patched-sur/big-sur-micropatcher-main ~/.patched-sur/big-sur-micropatcher")
                                    withAnimation {
                                        p = 4
                                    }
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else {
                    VStack {
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
                        Text("Click to Copy")
                            .font(.caption)
                    }
                }
            }
            .fixedSize()
        }
    }
}
