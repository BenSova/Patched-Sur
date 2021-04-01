//
//  HaxDownloadView.swift
//  Patched Sur
//
//  Created by Ben Sova on 1/29/21.
//

import SwiftUI

struct HaxDownloadView: View {
    @State var errorT = ""
    @State var done = false
    let installInfo: InstallAssistant?
//    let timer = Timer.publish(every: 0.50, on: .current, in: .common).autoconnect()
    @State var hasPassword = false
    @Binding var password: String
    @Binding var p: Int
    @Binding var useCurrent: Bool
    var body: some View {
        VStack {
            Text("Starting Installer Enviorment")
                .bold()
            Text("Since the installer checks to make sure your Mac is supported, we need to skip this check to make sure you can actually update macOS. To do this, we need to use ASentientBot's Hax.dylib to skip this check. This shouldn't take long and soon Patched Sur will be able to start downloading macOS.")
//                + Text("STAY HERE").bold() + Text(" because as soon as this is done, Patched Sur will need you to open it again."))
                .multilineTextAlignment(.center)
                .padding()
//                .onReceive(timer) { _ in
//                    if done {
//                        presentAlert(m: "Patched Sur Needs To Restart", i: "So that Patched Sur can properly inject the skip combatibilty check dynamic library, the app needs to restart. When you press \"Okay\" the app will close and you will have to reopen it within the next 10 minutes, otherwise it will open back up to the main screen. Otherwise, the update process will continue after the app restarts.")
//                        UserDefaults.standard.set(Date(), forKey: "installStarted")
//                        exit(0)
//                    }
//                }
            if hasPassword {
                ZStack {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                        .onAppear(perform: {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    print("Downloading Hax...")
                                    try call("curl -Lo Hax5.dylib https://raw.githubusercontent.com/BenSova/Patched-Sur/main/Extra%20Files/Hax5/Hax5.dylib", at: "~/.patched-sur")
                                    print("Confirming Hax permissions...")
                                    try call("chmod u+x ~/.patched-sur/Hax5.dylib")
                                    print("Injecting Hax...")
                                    try call("launchctl setenv DYLD_INSERT_LIBRARIES ~/.patched-sur/Hax5.dylib")
                                    try call("sudo launchctl setenv DYLD_INSERT_LIBRARIES ~/.patched-sur/Hax5.dylib", p: password)
                                    sleep(2)
//                                    print("Saving app instructions...")
//                                    UserDefaults.standard.set(try! installInfo!.jsonString()!, forKey: "installInfo")
//                                    UserDefaults.standard.set(AppInfo.usePredownloaded, forKey: "preDownloaded")
//                                    print("Prompting for app restart...")
//                                    done = true
                                    p = 3
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
            } else {
                EnterPasswordButton(password: $password) {
                    hasPassword = true
                } onSaveFail: {
                    print("Oh well.")
                }
            }
        }
    }
}
