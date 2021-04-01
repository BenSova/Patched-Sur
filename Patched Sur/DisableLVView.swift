//
//  DisableAMFIView.swift
//  Patched Sur
//
//  Created by Ben Sova on 1/22/21.
//

import SwiftUI

struct DisableAMFIView: View {
    @State var password = ""
    var body: some View {
        VStack {
            Text("Disable Library Validation")
                .bold()
            Text("Since the installer checks to see if the update supports your Mac, Patched Sur needs to inject a dylib into it so that the installer doesn't care about the incompatibilty. However, this can only be done with Library Validation off, so Patched Sur will quickly turn that off then restart your Mac, so then you can continue with updating.").padding()
                .multilineTextAlignment(.center)
            EnterPasswordButton(password: $password) {
                do {
                    try call("defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true", p: password)
                } catch {
                    print("Failed to change library validation status.")
                    presentAlert(m: "Failed to update boot-args", i: "Patched Sur was unable to disable library validation.", s: .warning)
                }
                do {
                    try call("reboot", p: password)
                } catch {
                    print("Failed to reboot, telling the user to do it themself.")
                    presentAlert(m: "Failed to Reboot", i: "You can do it yourself! Cmd+Control+Eject (or Cmd+Control+Power if you want it to be faster) will reboot your computer, or you can use the Apple logo in the corner of the screen. Your choice, they all work.", s: .warning)
                }
            }
        }
    }
}
