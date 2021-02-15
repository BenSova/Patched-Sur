//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI

struct Settings: View {
    @State private var showingAlert = false
    let releaseTrack: String
    @Binding var at: Int
    @State var hovered = nil as String?
    @State var password = ""
    @State var showPasswordPrompt = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Patched Sur Settings")
                        .bold()
                        .font(.title)
                    Spacer()
                    if at != -10 {
                        CustomColoredButton("Back to Home", hovered: $hovered) {
                            at = 0
                        }
                    }
                }
                HStack {
                    CustomColoredButton("Disable Animations", hovered: $hovered) {
                        disableAnimations()
                        self.showingAlert = true
                    }
                    CustomColoredButton("Enable Animations", hovered: $hovered) {
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
                CustomColoredButton("Contribute Your Experiences", hovered: $hovered) {
                    NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur-Compatibility")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                .padding(.bottom, 2)
                Text("The preinstall app in Patched Sur has a new feature letting new users know how well their Mac will work with Big Sur. However, something like this needs information, and that's what you can help with! Just click on the link above and follow the instructions to help out.")
                    .font(.caption)
                CustomColoredButton("Enable Graphics Switching", hovered: $hovered) {
                    showPasswordPrompt = true
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                .padding(.bottom, 2)
                .sheet(isPresented: $showPasswordPrompt, content: {
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            HStack {
                                Text("Patched Sur Requries Your Password to Contninue").bold()
                                    .font(Font.body.bold())
                                Spacer()
                                CustomColoredButton("Cancel", hovered: $hovered) {
                                    showPasswordPrompt = false
                                }
                            }.padding(.bottom)
                            EnterPasswordButton(password: $password) {
                                do {
                                    print("Stopping displaypolicyd...")
                                    _ = try? call("launchctl stop system/com.apple.displaypolicyd", p: password)
                                    print("Enabling Automatic Graphics Switching...")
                                    try call("launchctl disable system/com.apple.displaypolicyd", p: password)
                                    showPasswordPrompt = false
                                    presentAlert(m: "Graphics Switching Enabled", i: "Now graphics will switch automatically! A restart might be required for changes to take effect.", s: .informational)
                                } catch {
                                    showPasswordPrompt = false
                                    presentAlert(m: "Failed to Enable Graphics Switching", i: error.localizedDescription, s: .critical)
                                }
                            }
                        }
                    }.padding(20)
                })
                Text("If you have a Mac with mutliple GPUs, then you probably want automatic graphics switching enabled for graphics switching. Thanks to @15wat for finding this solution.")
                    .font(.caption)
                CustomColoredButton("Clean Leftovers", hovered: $hovered) {
                    _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
                    _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS Big\\ Sur*.app")
                    _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
                    _ = try? call("rm -rf ~/.patched-sur/trash")
                    presentAlert(m: "Cleaned Leftovers", i: "The files have been deleted, you should see some more free space (assuming that there actually were big files to be cleaned).", s: .informational)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                .padding(.bottom, 2)
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
            .padding(.leading, 2)
            .padding(.horizontal, 35)
        }.padding(.vertical, 25)
        .environment(\.releaseTrack, releaseTrack)
    }
}

struct CustomColoredButton: View {
    @Environment(\.releaseTrack) var releaseTrack
    let text: String
    let action: () -> ()
    @Binding var hovered: String?
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(hovered == text ? Color.accentColor.opacity(0.7) : .accentColor)
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 4)
            }.fixedSize()
            .cornerRadius(7.5)
        }
        .buttonStyle(BorderlessButtonStyle())
        .onHover {
            hovered = $0 ? text : nil
        }
    }
    
    init(_ text: String, hovered: Binding<String?>, action: @escaping () -> ()) {
        self.text = text
        self.action = action
        self._hovered = hovered
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
}
