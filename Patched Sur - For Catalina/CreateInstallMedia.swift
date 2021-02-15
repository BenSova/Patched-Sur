//
//  CreateInstallMedia.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI
import Files
import IOKit
import IOKit.pwr_mgt

struct CreateInstallMedia: View {
    @State var downloadStatus = "Erasing Disk..."
    @Binding var volume: String
    @Binding var password: String
    @Binding var overrideInstaller: Bool
    @State var diskID = ""
    @State var buttonBG = Color.red
    @State var copyProgress: CGFloat = 0.5
    @Binding var p: Int
    @Binding var installer: String?
    var body: some View {
        VStack {
            Text("Creating Install Media").bold()
            Text("Due to the fact that the installer app cannot be natively run on an unsupported Mac, you have to create an installer USB where the environment can be modified, so macOS doesn't check whether or not your Mac is supported. This can take up to a couple of hours, so let it run.")
                .padding()
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Erasing Disk..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Erasing Disk...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    print("Disabling bad Spotlight Indexing...")
                                    _ = try? call("launchctl disable system/com.apple.displaypolicyd", p: password)
                                    _ = try? call("launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    print("Stopping mds...")
                                    _ = try? call("killall mds", p: password)
                                    _ = try? call("killall mds_stores", p: password)
                                    print("Phrasing for diskID...")
                                    let diskUtilList = try call("diskutil list /Volumes/\(volume.replacingOccurrences(of: " ", with: "\\ "))")
                                    var diskStart = diskUtilList.split(separator: "\n")[2]
                                    diskStart.removeFirst("   0:      GUID_partition_scheme                        *32.0 GB    ".count)
                                    diskID = String(diskStart.prefix(6))
                                    if diskID.hasSuffix("s") { diskID.removeLast() }
                                    try call("diskutil eraseDisk JHFS+ Install\\ macOS\\ Big\\ Sur GPT \(diskID)")
                                    downloadStatus = "Copying Installer..."
                                } catch {
                                    _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Copying Installer..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Copying Installer...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    let reasonForActivity = "Reason for activity" as CFString
                                    var assertionID: IOPMAssertionID = 0
                                    var success = IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                                                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                                                reasonForActivity,
                                                                                &assertionID )
                                    if success == kIOReturnSuccess {
                                        print("Stopping mds again...")
                                        _ = try? call("killall mds", p: password)
                                        print("Starting createinstallmedia...")
                                        if (try? shellOut(to: "[[ -d /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app ]]")) != nil {
                                            try call("\(installer?.replacingOccurrences(of: " ", with: "\\ ") ?? "/Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app")/Contents/Resources/createinstallmedia --volume /Volumes/Install\\ macOS\\ Big\\ Sur --nointeraction", p: password)
                                        } else {
                                            try call("\(installer?.replacingOccurrences(of: " ", with: "\\ ") ?? "/Applications/Install\\ macOS\\ Big\\ Sur.app")/Contents/Resources/createinstallmedia --volume /Volumes/Install\\ macOS\\ Big\\ Sur --nointeraction", p: password)
                                        }
                                        success = IOPMAssertionRelease(assertionID)
                                        downloadStatus = "Adding Kexts..."
                                    } else {
                                        downloadStatus = "Unable to pull system attention."
                                    }
                                } catch {
                                    _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Adding Kexts..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Patching USB...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try call("/Volumes/Patched-Sur/.patch-usb.sh", p: password)
                                    downloadStatus = "Injecting Full App..."
                                } catch {
                                    _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Injecting Full App..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Injecting Full App...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .utility).async {
                                do {
                                    _ = try call("rm -rf \"/Applications/Patched Sur.app\"")
                                    try call("cp -rf \"/Volumes/Patched-Sur/.fullApp.app\" \"/Applications/Patched Sur.app\"")
                                    _ = try? call("sudo sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    withAnimation {
                                        p = 8
                                    }
                                } catch {
                                    _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
                                    _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
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
                                    .lineLimit(6)
                                    .padding(6)
                                    .padding(.horizontal, 4)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        Text("Click to Copy")
                            .font(.caption)
                    }
                }
            }.fixedSize()
        }
    }
}

extension URL {
    var fileSize: Int? { // in bytes
        do {
            let val = try self.resourceValues(forKeys: [.totalFileAllocatedSizeKey, .fileAllocatedSizeKey])
            return val.totalFileAllocatedSize ?? val.fileAllocatedSize
        } catch {
            print(error)
            return nil
        }
    }
}

extension FileManager {
    func directorySize(_ dir: URL) -> Int? { // in bytes
        if let enumerator = self.enumerator(at: dir, includingPropertiesForKeys: [.totalFileAllocatedSizeKey, .fileAllocatedSizeKey], options: [], errorHandler: { (_, error) -> Bool in
            print(error)
            return false
        }) {
            var bytes = 0
            for case let url as URL in enumerator {
                bytes += url.fileSize ?? 0
            }
            return bytes
        } else {
            return nil
        }
    }
}
