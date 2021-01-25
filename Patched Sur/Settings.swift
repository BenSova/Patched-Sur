//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI
import SwiftShell

struct Settings: View {
    @State private var showingAlert = false
    let releaseTrack: String
    @Binding var at: Int
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Patched Sur Settings")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                        CustomColoredButton("Back to Home") {
                            at = 0
                        }
                    }
                    HStack {
                        CustomColoredButton("Disable Animations") {
                            disableAnimations()
                            self.showingAlert = true
                        }
                        CustomColoredButton("Enable Animations") {
                            enableAnimations()
                            self.showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Changes Made Successfully"), message: Text("A reboot is required to apply these changes."), dismissButton: .default(Text("Okay")))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("Manage Animations. Disabling animations can greatly improve performance on Macs without Metal. A reboot is required to apply these changes.")
                    CustomColoredButton("Contribute Your Expriences") {
                        NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur-Compatibility")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("The preinstall app in Patched Sur has a new feature letting new users know how well their Mac will work with Big Sur. However, something like this needs information, and that's what you can help with! Just click on the link above and follow the instructions to help out.")
                        .font(.caption)
                    CustomColoredButton("Clean Leftovers") {
                        _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
                        _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS Big\\ Sur*.app")
                        _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
                        _ = try? call("rm -rf ~/.patched-sur/trash")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    HStack {
                        CustomColoredButton("Enable Quick-Wake") {
                            _ = try? call("sudo pmset -a standbydelay 86400")
                            self.showingAlert = true
                        }
                        CustomColoredButton("Disable Quick-Wake") {
                            _ = try? call("sudo pmset -a standbydelay 10800")
                            self.showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Changes Made Successfully"), message: Text("You may need to reboot for the changes to take effect."), dismissButton: .default(Text("Okay")))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("If your Mac is taking a while to wake from sleep, this may help. What it will do is increase the amount of time before it reaches a 'deep sleep' state. PLEASE NOTE: This may slightly reduce battery life.")
                    Group {
                        HStack {
                            CustomColoredButton("Empty RAM") {
                                _ = try? call("sudo purge")
                                self.showingAlert = true
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("RAM Successfully Purged"), message: Text(""), dismissButton: .default(Text("Okay")))
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }.padding(.top, 10)
                        .padding(.bottom, 2)
                        Text("Purging your RAM may temporarily increase speeds. WARNING: Running this operation may break applications. The developers are not responsible for any damage done by this process.")
                    }
                    Group {
                    Text("Sometimes, Patched Sur accidentally leaves little leftovers from when something ran. This could at times save 12GB of storage space, this is suggested especially after you run the updater.")
                        .font(.caption)
                    Text("Patched Sur by Ben Sova")
                        .bold()
                        .padding(.top, 5)
                    Text("Thanks to BarryKN, ASentientBot, jackluke, highvoltage12v, ParrotGeek, testheit, Ausdauersportler, StarPlayrX, ASentientHedgehog, John_Val, fromeister2009 and many others!")
                        .font(.caption)
                    }
                }.font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading, 2)
                .padding(.horizontal, 35)
            }.padding(.vertical, 25)
        }
        .environment(\.releaseTrack, releaseTrack)
    }
}

struct CustomColoredButton: View {
    @Environment(\.releaseTrack) var releaseTrack
    let text: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                if releaseTrack == "Public Beta" {
                    Rectangle().foregroundColor(.init("Blue"))
                } else if releaseTrack == "Developer" {
                    Rectangle().foregroundColor(.red)
                } else if releaseTrack == "Release" {
                    Rectangle().foregroundColor(.accentColor)
                }
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 4)
            }.fixedSize()
            .cornerRadius(7.5)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    init(_ text: String, action: @escaping () -> ()) {
        self.text = text
        self.action = action
    }
}

extension EnvironmentValues {
    private struct ReleaseTrackKey: EnvironmentKey {
        static let defaultValue = "Release"
    }
    
    public var releaseTrack: String {
        get {
            self[ReleaseTrackKey]
        } set {
            self[ReleaseTrackKey] = newValue
        }
    }
}

func disableAnimations() {
    _ = try? call("defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
    _ = try? call("defaults write -g NSScrollAnimationEnabled -bool false")
    _ = try? call("defaults write -g NSWindowResizeTime -float 0.001")
    _ = try? call("defaults write -g QLPanelAnimationDuration -float 0")
    _ = try? call("defaults write -g NSScrollViewRubberbanding -bool false")
    _ = try? call("defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
    _ = try? call("defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
    _ = try? call("defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
    _ = try? call("defaults write com.apple.dock autohide-time-modifier -float 0")
    _ = try? call("defaults write com.apple.dock autohide-delay -float 0")
    _ = try? call("defaults write com.apple.dock expose-animation-duration -float 0")
    _ = try? call("defaults write com.apple.dock springboard-show-duration -float 0")
    _ = try? call("defaults write com.apple.dock springboard-hide-duration -float 0")
    _ = try? call("defaults write com.apple.dock springboard-page-duration -float 0")
    _ = try? call("defaults write com.apple.finder DisableAllAnimations -bool true")
    _ = try? call("defaults write com.apple.Mail DisableSendAnimations -bool true")
    _ = try? call("defaults write com.apple.Mail DisableReplyAnimations -bool true")
    _ = try? call("defaults write NSGlobalDomain NSWindowResizeTime .001")
    _ = try? call("defaults write com.apple.Dock autohide-delay -float 0") // Disables delay when hiding Dock
    _ = try? call("defaults write com.apple.dock launchanim -bool false")  // Disables animations when opening application from Dock
    _ = try? call("defaults write com.apple.dock expose-animation-duration -float 0.1")  // Makes Mission Control Animations Faster
    _ = try? call("defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25")  // Disables Safari web rendering delay
}

func enableAnimations() {
    _ = try? call("defaults delete -g NSAutomaticWindowAnimationsEnabled")
    _ = try? call("defaults delete -g NSScrollAnimationEnabled")
    _ = try? call("defaults delete -g NSWindowResizeTime")
    _ = try? call("defaults delete -g QLPanelAnimationDuration")
    _ = try? call("defaults delete -g NSScrollViewRubberbanding")
    _ = try? call("defaults delete -g NSDocumentRevisionsWindowTransformAnimation")
    _ = try? call("defaults delete -g NSToolbarFullScreenAnimationDuration")
    _ = try? call("defaults delete -g NSBrowserColumnAnimationSpeedMultiplier")
    _ = try? call("defaults delete com.apple.dock autohide-time-modifier")
    _ = try? call("defaults delete com.apple.dock autohide-delay")
    _ = try? call("defaults delete com.apple.dock expose-animation-duration")
    _ = try? call("defaults delete com.apple.dock springboard-show-duration")
    _ = try? call("defaults delete com.apple.dock springboard-hide-duration")
    _ = try? call("defaults delete com.apple.dock springboard-page-duration")
    _ = try? call("defaults delete com.apple.finder DisableAllAnimations")
    _ = try? call("defaults delete com.apple.Mail DisableSendAnimations")
    _ = try? call("defaults delete com.apple.Mail DisableReplyAnimations")
    _ = try? call("defaults delete NSGlobalDomain NSWindowResizeTime")
    _ = try? call("defaults delete com.apple.Dock autohide-delay")
    _ = try? call("defaults delete com.apple.dock launchanim")
    _ = try? call("defaults delete com.apple.dock expose-animation-duration")
    _ = try? call("defaults delete com.apple.Safari WebKitInitialTimedLayoutDelay")
}

