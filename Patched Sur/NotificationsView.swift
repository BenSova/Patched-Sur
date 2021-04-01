//
//  NotificationsView.swift
//  Patched Sur
//
//  Created by Ben Sova on 2/25/21.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @State var hovered: String? = ""
    @State var notifications = "NOTHING"
    @State var autoUpdate = "NOUPDATE"
    @Binding var p: Int
    @State var showPassword = false
    @State var password = ""
    @State var allowNotifications = false
    var body: some View {
        VStack {
            Text("Update Notifications")
                .font(Font.body.bold())
            Text("Since your Mac is unsupported, Software Update will never inform you about macOS updates, because it doesn't have anything new that supports your Mac. However, Patched Sur can provide this functionality on it's own, also providing for notifications for updates to the patcher if you would like.")
                .padding()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .font(.body)
            // MARK: - Get Notifications For
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Get notifications for")
                        .padding(6)
                        .padding(.leading, 4)
                    Button {
                        notifications = "NOTHING"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "NOTHING" ? (notifications == "NOTHING" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "NOTHING" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "NOTHING" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "MACOS"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "MACOS" ? (notifications == "MACOS" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("macOS")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "MACOS" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "MACOS" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "PATCHEDSUR"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "PATCHEDSUR" ? (notifications == "PATCHEDSUR" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "PATCHEDSUR" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "PATCHEDSUR" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "BOTH"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "BOTH" ? (notifications == "BOTH" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Both")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "BOTH" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "BOTH" : ""
                    }
                }
            }.fixedSize()
            // MARK: - Automatically Update Patched Sur
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Automatically Update")
                        .padding(6)
                        .padding(.leading, 4)
                    Button {
                        autoUpdate = "AUTOUPDATE"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "AUTOUPDATE" ? (autoUpdate == "AUTOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(autoUpdate == "AUTOUPDATE" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "AUTOUPDATE" : ""
                    }.padding(.trailing, 5)
                    Button {
                        autoUpdate = "NOUPDATE"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "NOUPDATE" ? (autoUpdate == "NOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(autoUpdate == "NOUPDATE" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "NOUPDATE" : ""
                    }
                }
            }.fixedSize()
            // MARK: - Confirm
            HStack {
                Button {
                    p = 2
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(hovered != "BACK" ? Color.accentColor.opacity(0.2) : Color.accentColor.opacity(0.5))
                            .cornerRadius(10)
                        Text("Back")
                            .padding(6)
                            .padding(.horizontal, 4)
                            .foregroundColor(.primary)
                    }.fixedSize()
                }.buttonStyle(BorderlessButtonStyle())
                .onHover {
                    hovered = $0 ? "BACK" : ""
                }
                Button {
                    showPassword = true
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(hovered != "CONFIRM" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                            .cornerRadius(10)
                        Text("Confirm")
                            .padding(6)
                            .padding(.horizontal, 4)
                            .foregroundColor(.white)
                    }.fixedSize()
                }.buttonStyle(BorderlessButtonStyle())
                .onHover {
                    hovered = $0 ? "CONFIRM" : ""
                }
            }.padding(.top, 5)
            .sheet(isPresented: $showPassword) {
                ZStack(alignment: .topTrailing) {
                    VStack {
                        if !allowNotifications {
                            HStack {
                                Text("Patched Sur Requries Your Password to Setup a Daemon").bold()
                                    .font(Font.body.bold())
                                Spacer()
                                CustomColoredButton("Cancel", hovered: $hovered) {
                                    showPassword = false
                                }
                            }.padding(.bottom)
                            EnterPasswordButton(password: $password) {
                                do {
                                    print("Setting up Launchctl...")
                                    _ = try? call("launchctl unload /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                    _ = try? call("rm -rf /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                    try call("curl -Lo /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist https://raw.githubusercontent.com/BenSova/Patched-Sur/main/Extra%20Files/PatchedSurDaemon.plist", p: password)
                                    try call("launchctl load -w /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                    _ = try? call("launchctl enable system/u-bensova.Patched-Sur.Daemon", p: password)
                                    print("Saving configuration...")
                                    UserDefaults.standard.setValue(notifications, forKey: "Notifications")
                                    UserDefaults.standard.setValue(autoUpdate, forKey: "AutoUpdate")
                                    print("Prompting for allow notifications...")
                                    allowNotifications = true
                                } catch {
                                    showPassword = false
                                    presentAlert(m: "Failed to Configure Daemon", i: error.localizedDescription, s: .informational)
                                }
                            }
                        } else {
                            Text("Patched Sur needs permissions to send notifications to continue.")
                                .onAppear {
                                    if notifications == "NOTHING" {
//                                        presentAlert(m: "Setup Notifications!", i: "Patched Sur will correctly notify you about the updates based on your new preferences.", s: .informational)
                                        showPassword = false
                                        allowNotifications = false
                                        p = 2
                                    } else {
                                        let center = UNUserNotificationCenter.current()
                                        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                                            if let error = error {
                                                print("Failed to allow notifications")
                                                print(error.localizedDescription)
//                                                presentAlert(m: "Patched Sur Cannot Send Notifcations", i: "You must of denied Patched Sur from sending notifications. If you want Patched Sur to send notifcations, open System Preferences > Notifications > Patched Sur then allow notifcations.\n\nError: \(error.localizedDescription)", s: .informational)
                                            }
                                            
                                            if granted {
                                                print("Allowed notifcations!")
//                                                presentAlert(m: "Setup Notifications!", i: "Patched Sur will correctly notify you about the updates based on your new preferences.", s: .informational)
                                            }
                                        }
                                        showPassword = false
                                        allowNotifications = false
                                        p = 2
                                    }
                                }
                        }
                    }
                }.padding(20)
            }
        }
        .onAppear {
            notifications = UserDefaults.standard.string(forKey: "Notifications") ?? "NOTHING"
            autoUpdate = UserDefaults.standard.string(forKey: "AutoUpdate") ?? "NOUPDATE"
        }
    }
}
