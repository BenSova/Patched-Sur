//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI

struct Settings: View {
    let releaseTrack: String
    @Binding var at: Int
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            HStack {
                SideImageView(releaseTrack: releaseTrack)
                    .padding(.leading, 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Patched Sur Settings")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                    HStack {
                        Button {
                            _ = try? shellOut(to: "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
                            _ = try? shellOut(to: "defaults write -g NSScrollAnimationEnabled -bool false")
                            _ = try? shellOut(to: "defaults write -g NSWindowResizeTime -float 0.001")
                            _ = try? shellOut(to: "defaults write -g QLPanelAnimationDuration -float 0")
                            _ = try? shellOut(to: "defaults write -g NSScrollViewRubberbanding -bool false")
                            _ = try? shellOut(to: "defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
                            _ = try? shellOut(to: "defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
                            _ = try? shellOut(to: "defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock autohide-time-modifier -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock autohide-delay -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock expose-animation-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-show-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-hide-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-page-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.finder DisableAllAnimations -bool true")
                            _ = try? shellOut(to: "defaults write com.apple.Mail DisableSendAnimations -bool true")
                            _ = try? shellOut(to: "defaults write com.apple.Mail DisableReplyAnimations -bool true")
                            _ = try? shellOut(to: "defaults write NSGlobalDomain NSWindowResizeTime .001")
                            func dialogOKCancel(question: String, text: String) -> Bool {
                                let alert = NSAlert()
                                alert.messageText = question
                                alert.informativeText = text
                                alert.alertStyle = .warning
                                alert.addButton(withTitle: "OK")
                                alert.addButton(withTitle: "Cancel")
                                return alert.runModal() == .alertFirstButtonReturn
                            }

                            let answer = dialogOKCancel(question: "Changes made Sucessfully", text: "Reboot to apply changes")
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.blue)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.green)
                                }
                                Text("Disable Animations")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            _ = try? shellOut(to: "defaults delete -g NSAutomaticWindowAnimationsEnabled")
                            _ = try? shellOut(to: "defaults delete -g NSScrollAnimationEnabled")
                            _ = try? shellOut(to: "defaults delete -g NSWindowResizeTime")
                            _ = try? shellOut(to: "defaults delete -g QLPanelAnimationDuration")
                            _ = try? shellOut(to: "defaults delete -g NSScrollViewRubberbanding")
                            _ = try? shellOut(to: "defaults delete -g NSDocumentRevisionsWindowTransformAnimation")
                            _ = try? shellOut(to: "defaults delete -g NSToolbarFullScreenAnimationDuration")
                            _ = try? shellOut(to: "defaults delete -g NSBrowserColumnAnimationSpeedMultiplier")
                            _ = try? shellOut(to: "defaults delete com.apple.dock autohide-time-modifier")
                            _ = try? shellOut(to: "defaults delete com.apple.dock autohide-delay")
                            _ = try? shellOut(to: "defaults delete com.apple.dock expose-animation-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-show-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-hide-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-page-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.finder DisableAllAnimations")
                            _ = try? shellOut(to: "defaults delete com.apple.Mail DisableSendAnimations")
                            _ = try? shellOut(to: "defaults delete com.apple.Mail DisableReplyAnimations")
                            _ = try? shellOut(to: "defaults delete NSGlobalDomain NSWindowResizeTime")
                            Alert(title: Text("Changes made sucessfully"), message: Text("Reboot to apply changes"), dismissButton: .default(Text("Got it")))
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.blue)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.green)
                                }
                                Text("Enable Animations")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("Manage Animations. Disabling animations can greatly improve performance on Macs without Metal. A reboot is required to apply these changes.")
                        .font(.caption)
                    Button {
                        at = 0
                    } label: {
                        ZStack {
                            if releaseTrack == "Public Beta" {
                                Rectangle().foregroundColor(.blue)
                            } else if releaseTrack == "Developer" {
                                Rectangle().foregroundColor(.orange)
                            } else if releaseTrack == "Release" {
                                Rectangle().foregroundColor(.green)
                            }
                            Text("Back to Home")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(4)
                                .padding(.horizontal, 4)
                        }.fixedSize()
                        .cornerRadius(7.5)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 11)
                }.font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading, 2)
                .padding(.trailing, 30)
            }
        }
    }
}





/*
shellOut(to: "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
shellOut(to: "defaults write -g NSScrollAnimationEnabled -bool false")
shellOut(to: "defaults write -g NSWindowResizeTime -float 0.001")
shellOut(to: "defaults write -g QLPanelAnimationDuration -float 0")
shellOut(to: "defaults write -g NSScrollViewRubberbanding -bool false")
shellOut(to: "defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
shellOut(to: "defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
shellOut(to: "defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
shellOut(to: "defaults write com.apple.dock autohide-time-modifier -float 0")
shellOut(to: "defaults write com.apple.dock autohide-delay -float 0")
shellOut(to: "defaults write com.apple.dock expose-animation-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-show-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-hide-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-page-duration -float 0")
shellOut(to: "defaults write com.apple.finder DisableAllAnimations -bool true")
shellOut(to: "defaults write com.apple.Mail DisableSendAnimations -bool true")
shellOut(to: "defaults write com.apple.Mail DisableReplyAnimations -bool true")
shellOut(to: "defaults write NSGlobalDomain NSWindowResizeTime .001")
*/
