//
//  UpdateView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/24/20.
//

import SwiftUI
import Files

struct UpdateView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var at: Int
    @State var progress = 0
    @State var installers = nil as InstallAssistants?
    @State var track = ReleaseTrack.release
    @State var latestPatch = nil as PatchedVersion?
    #if DEBUG
    @State var skipAppCheck = true
    #else
    @State var skipAppCheck = false
    #endif
    @State var installInfo = nil as InstallAssistant?
    @State var packageLocation = "~/.patched-sur/InstallAssistant.pkg"
    @State var password = ""
    @State var useCurrent = false
    let buildNumber: String
    var body: some View {
        ZStack {
            if progress == 0 {
                VStack {
                    Text("Software Update")
                        .font(.title2)
                        .bold()
                    Spacer()
                }.padding(25)
            }
            switch progress {
            case 0:
                UpdateCheckerView(at: $at, progress: $progress, installers: $installers, track: $track, latestPatch: $latestPatch, skipAppCheck: $skipAppCheck, installInfo: $installInfo)
            case 1:
                UpdateAppView(latest: latestPatch!, p: $progress, skipCheck: $skipAppCheck)
            case -1:
                Text("Hi You! You shouldn't really be seeing this, but here you are!")
                    .onAppear {
                        progress = 0
                        at = 0
                    }
            case 2:
                UpdateStatusView(installers: installers, installInfo: $installInfo, releaseTrack: $track, buildNumber: buildNumber, p: $progress)
            case 3:
                DownloadView(p: $progress, installInfo: $installInfo, useCurrent: $useCurrent)
            case 4:
                StartInstallView(password: $password, installerPath: $packageLocation)
            case 5:
                InstallerChooser(p: $progress, installInfo: $installInfo, track: $track, useCurrent: $useCurrent, package: $packageLocation)
            case 6:
                DisableAMFIView()
            case 7:
                HaxDownloadView(installInfo: installInfo, password: $password, p: $progress, useCurrent: $useCurrent)
            case 8:
                NotificationsView(p: $progress).font(.caption)
            default:
                Text("Sad")
            }
        }
        .navigationTitle("Patched Sur")
    }
}

//            case 5:
//                InstallerChooser()

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String { rawValue }
}

struct UpdateCheckerView: View {
    @Binding var at: Int
    @Binding var progress: Int
    @Binding var installers: InstallAssistants?
    @Binding var track: ReleaseTrack
    @Binding var latestPatch: PatchedVersion?
    @Binding var skipAppCheck: Bool
    @Binding var installInfo: InstallAssistant?
    @State var checkingForUpdatesText = "Checking For Updates..."
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            if checkingForUpdatesText == "Checking For Updates..." {
                Text(checkingForUpdatesText)
                    .font(.title2)
                    .fontWeight(.semibold)
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            do {
                                print("Checking for updates to Patched Sur...")
                                if !skipAppCheck, let patchedVersions = try? PatchedVersions(fromURL: "https://api.github.com/repos/BenSova/Patched-Sur/releases").filter({ !$0.prerelease }) {
                                    if patchedVersions[0].tagName != "v\(AppInfo.version)" {
                                        latestPatch = patchedVersions[0]
                                        progress = 1
                                        print("Found update \(latestPatch?.tagName ?? "INVALID").")
                                        print("Offering update.\n")
                                        return
                                    }
                                }
                                print("No updates found or user choose to skip the app update check.")
                                print("Figuring out what update track to use...")
                                track = ReleaseTrack(rawValue: UserDefaults.standard.string(forKey: "UpdateTrack") ?? "Release") ?? .release
                                print("Using update track \(track).")
                                print("Pinging installer list to find the latest updates...")
                                installers = try InstallAssistants(fromURL:  URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : (track == .publicbeta ? "Public" : "Release")).json")!)
                                print("Filtering incompatible installers...")
                                installers = installers!.filter { $0.minVersion <= AppInfo.build }
                                print("Finding latest build...")
                                installers!.sort { $0.orderNumber < $1.orderNumber }
                                installInfo = installers!.last
                                if AppInfo.debug {
                                    print("Latest Build: \(installers!.last!.buildNumber)")
                                    print("Install Info: \(installInfo!.buildNumber)")
                                }
                                print("Switching to show updates screen...")
                                print("")
                                progress = 2
                            } catch {
                                print("Failed to fetch installer list.")
                                print(error.localizedDescription)
                                checkingForUpdatesText = error.localizedDescription
                            }
                        }
                    }
            } else {
                VStack {
                    Text("Failed to Check For Updates")
                        .bold()
                        .padding(.top, 10)
                    Text("This probably means either your WiFi connection is down, or GitHub's web-hosting servers are down. This shouldn't be much of a problem, assuming you can update macOS manually with the pre-install app, or update the patcher app itself by downloading from the Patched Sur GitHub page.")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(checkingForUpdatesText, forType: .string)
                    } label: {
                        ZStack {
                            Color.red
                                .cornerRadius(10)
                                .frame(minWidth: 200, maxWidth: 450)
                            Text(checkingForUpdatesText)
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
                        .padding(.bottom, 5)
                    Button {
                        at = 0
                        checkingForUpdatesText = "Checking For Updates..."
                    } label: {
                        ZStack {
                            buttonBG
                                .cornerRadius(10)
                            Text("Back")
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.horizontal, 10)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        buttonBG = $0 ? Color.accentColor.opacity(0.7) : Color.accentColor
                    }
                }
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
            }
        }
        .fixedSize()
    }
}
