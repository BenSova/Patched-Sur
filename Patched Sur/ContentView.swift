//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var atLocation: Int
    let releaseTrack: String
    var model: String
    var buildNumber: String
    var problemDetected = false
    var body: some View {
        ZStack {
//            colorScheme == .dark ? Color.black : Color.white
            if atLocation == 0 {
                MainView(at: $atLocation, buildNumber: buildNumber, model: model, problemDetected: problemDetected)
            } else if atLocation == 1 {
                UpdateView(at: $atLocation, buildNumber: buildNumber)
            } else if atLocation == 2 {
                KextPatchView(at: $atLocation)
            } else if atLocation == 3 {
                AboutMyMac(releaseTrack: releaseTrack, model: model, buildNumber: buildNumber, at: $atLocation)
            } else if atLocation == 4 {
                Settings(releaseTrack: releaseTrack, at: $atLocation)
            } else if atLocation == 5 {
                ResolveAMFI(at: $atLocation)
            } else {
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }.frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("v\(AppInfo.version) (\(AppInfo.build))")
                        .font(.caption)
                        .padding()
                }
            }
        }
    }
    
    init(at: Binding<Int>) {
        _ = try? call("[[ -d ~/.patched-sur ]] || mkdir ~/.patched-sur")
        model = (try? call("nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product")) ?? "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product \((try? call("sysctl -n hw.model")) ?? "MacModelX,Y")"
        model.removeFirst("4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product ".count)
        print("Detected Mac Model: \(model)")
        buildNumber = (try? call("sw_vers | grep BuildVersion:")) ?? "20xyyzzz"
        if buildNumber.count > 14 {
            buildNumber.removeFirst(14)
        } else {
            AppInfo.preventUpdate = true
        }
        print("Detected macOS Build Number: \(buildNumber)")
        var track = UserDefaults.standard.string(forKey: "UpdateTrack")
        if track == nil { track = "Release" }
        releaseTrack = track!
        print("Detected Release Track: \(releaseTrack)")
        
        print("Detecting AMFI Problems!")
        if let bootArgs = try? call("nvram boot-args"), (bootArgs.contains("amfi_get_out_of_my_way=1") || bootArgs.contains("amfi_get_out_of_my_way=0x1")) {
            print("\n=== A POTENTIAL PROBLEM WAS DETECTED! ===")
            print("AMFI is disabled, this could prevent you from")
            print("giving permissions, like camera and microphone,")
            print("to new apps.")
            problemDetected = true
            print("=========================================\n")
        }
        
        print("Loading Main Screen...")
        print("")
        self._atLocation = at
    }
}

struct MainView: View {
    @State var hovered = -1
    @Binding var at: Int
    var buildNumber: String
    var model: String
    let problemDetected: Bool
    var body: some View {
        ZStack {
            VStack {
                Text("Patched Sur")
                    .font(.title2)
                    .fontWeight(.heavy)
                Text("v\(AppInfo.version) (\(AppInfo.build))")
                    .padding(.bottom, 3)
                HStack {
                    Button {
                        withAnimation(Animation.linear(duration: 0)) {
                            if buildNumber.count >= 5 {
                                at = 1
                            } else {
                                print("Some details were failed to fetch in the inital launch sequence.")
                                print("Warning user, and attempting to recover.")
                                do {
                                    try call("[[ -d ~/.patched-sur ]] || mkdir ~/.patched-sur")
                                    try call("[[ -e ~/.patched-sur/track.txt ]] || echo Release > ~/.patched-sur/track.txt")
                                    presentAlert(m: "Patched Sur Needs To Restart", i: "The Patched Sur app encountered a problem during launch that prevented access to some necessary data that is required during updates. Patched Sur ran some operations that should protect against this problem, and simply restarting the app should fix this problem. When you click okay, the app will close and then you should be able to open it again and this problem will be solved.", s: .informational)
                                    exit(0)
                                } catch {
                                    presentAlert(m: "Patched Sur Does Not Have The Required Information To Update", i: "The Patched Sur app encountered a problem during launch that prevented access to some necessary data that is required during updates. Patched Sur ran some opperations that would protect against this problem, but these failed. This problem should rarely happen, but it did so there's not much I can do.\n\n\(error.localizedDescription)")
                                }
                            }
                        }
                    } label: {
                        VStack {
                            Image(systemName: "arrow.clockwise.circle")
                                .font(Font.system(size: 90).weight(.ultraLight))
                            Text("Update macOS")
                                .font(.title3)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background((hovered == 0) ? Color.init("AccentColor-1").opacity(0.15).cornerRadius(20) : Color.clear.opacity(0.0001).cornerRadius(20))
                        .onHover { (hovering) in
                            hovered = hovering ? 0 : -1
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
    //                .padding(.leading, 1)
                    Button {
                        if !model.hasPrefix("iMac14,") {
                            at = 2
                        } else {
                            let errorAlert = NSAlert()
                            errorAlert.alertStyle = .informational
                            errorAlert.informativeText = "You don't need to patch the kexts on Late 2013 iMacs. Big Sur is already running at full functionality."
                            errorAlert.messageText = "Patch Kexts Unnecessary"
                            errorAlert.runModal()
                        }
                    } label: {
                        VStack {
                            Image(systemName: "doc.circle")
                                .font(Font.system(size: 90).weight(.ultraLight))
                            Text("Patch Kexts")
                                .font(.title3)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background((hovered != 1) ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                        .onHover(perform: { hovering in
                            hovered = hovering ? 1 : -1
                        })
                    }
                    .buttonStyle(BorderlessButtonStyle())
    //                .padding(1)
                    Button {
                        at = 3
                    } label: {
                        VStack {
                            Image(systemName: "info.circle")
                                .font(Font.system(size: 90).weight(.ultraLight))
                            Text("About This Mac")
                                .font(.title3)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(hovered != 2 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                        .onHover(perform: { hovering in
                            hovered = hovering ? 2 : -1
                        })
                    }
                    .buttonStyle(BorderlessButtonStyle())
    //                .padding(.trailing, 1)
                    Button {
                        at = 4
                    } label: {
                        VStack {
                            Image(systemName: "command.circle")
                                .font(Font.system(size: 90).weight(.ultraLight))
                            Text("Settings")
                                .font(.title3)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(hovered != 3 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                        .onHover(perform: { hovering in
                            hovered = hovering ? 3 : -1
                        })
                    }
                    .buttonStyle(BorderlessButtonStyle())
    //                .padding(.trailing, 1)
                }
            }.navigationTitle("Patched Sur")
        }
        if problemDetected {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        at = 5
                    } label: {
                        ZStack {
                            Color.red
                                .cornerRadius(20)
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text("Patched Sur detected a potential problem!")
                                    .padding(.horizontal, 15)
                                Image(systemName: "chevron.right.circle.fill")
                            }.opacity(hovered == -2 ? 0.6 : 1).padding(5).foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? -2 : -1
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}
