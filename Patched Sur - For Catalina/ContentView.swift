//
//  ContentView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            AllViews()
        }
        .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AllViews : View {
    @State var progress = 0
    @State var password = ""
    @State var volume = ""
    @State var overrideinstaller = false
    @State var releaseTrack = ReleaseTrack.release
    @State var installMethod = InstallMethod.update
    @State var installInfo = nil as InstallAssistant?
    @State var useCurrent = false
    @State var packageLocation = "~/.patched-sur/InstallAssistant.pkg"
    @State var appLocation = nil as String?
    var body: some View {
        ZStack {
            switch progress {
            case 0:
                ZStack {
                    MainView(p: $progress).transition(.moveAway)
    //                EnterPasswordPrompt(password: $password, show: .constant(true))
                }
            case 1:
                MacCompatibility(p: $progress).transition(.moveAway)
            case 2:
                HowItWorks(p: $progress).transition(.moveAway)
            case 9:
                ReleaseTrackView(track: $releaseTrack, p: $progress).transition(.moveAway)
            case 10:
                InstallMethodView(method: $installMethod, p: $progress).transition(.moveAway)
            case 3:
                DownloadView(p: $progress).transition(.moveAway)
            case 4:
                InstallPackageView(installInfo: $installInfo, password: $password, p: $progress, overrideInstaller: $overrideinstaller, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
            case 5:
                VolumeSelector(p: $progress, volume: $volume).transition(.moveAway)
            case 6:
                ConfirmVolumeView(volume: $volume, p: $progress).transition(.moveAway)
            case 7:
                CreateInstallMedia(volume: $volume, password: $password, overrideInstaller: $overrideinstaller, p: $progress, installer: $appLocation).transition(.moveAway)
            case 8:
                FinishedView(app: appLocation ?? "/Applications/Install macOS Big Sur Beta.app/").transition(.moveAway)
            case 11:
                InstallerChooser(p: $progress, installInfo: $installInfo, track: $releaseTrack, useCurrent: $useCurrent, package: $packageLocation, installer: $appLocation).transition(.moveAway)
            default:
                Text("Uh-oh Looks like you went to the wrong page. Error 0x\(progress)").transition(.moveAway)
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
}

enum ReleaseTrack: String, CustomStringConvertible {
    case release = "Release"
    case publicbeta = "Public Beta"
    case developer = "Developer"
    
    var description: String {
        rawValue
    }
}
