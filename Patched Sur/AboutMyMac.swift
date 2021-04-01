//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI

struct AboutMyMac: View {
    var systemVersion: String
    let releaseTrack: String
    var gpu: String
    var model: String
    var cpu: String
    var memory: String
    let buildNumber: String
    @Binding var at: Int
    
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            HStack {
                SideImageView(releaseTrack: releaseTrack)
                VStack(alignment: .leading, spacing: 2) {
                    Text("macOS ").font(.largeTitle).bold() + Text("Big Sur").font(.largeTitle)
                    Text("Version \(systemVersion)\(buildNumber.count == 5 ? "" : " Beta") (\(buildNumber))").font(.subheadline)
                    Rectangle().frame(height: 15).opacity(0).fixedSize()
                    Text("Model         ").font(.subheadline).bold() + Text(model)
                    Text("CPU            ").font(.subheadline).bold() + Text(cpu)
                    Text("GPU            ").font(.subheadline).bold() + Text(gpu)
                    Text("Memory     ").bold() + Text(memory) + Text("GB")
                    HStack {
                        Button {
                            at = 0
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.init("Blue"))
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.accentColor)
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
                        Button {
                            at = 1
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.init("Blue"))
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.accentColor)
                                }
                                Text("Software Update")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                }.font(.subheadline)
                .foregroundColor(.white)
            }
        }
    }
    
    init(releaseTrack: String, model: String, buildNumber: String, at: Binding<Int>) {
        self.releaseTrack = releaseTrack
        self.model = model
        self.buildNumber = buildNumber
        self._at = at
        memory = (try? call("echo \"$(($(sysctl -n hw.memsize) / 1024 / 1024 / 954))\"")) ?? "-100"
        print("Detected Memory Amount: \(memory)")
        gpu = (try? call("system_profiler SPDisplaysDataType | awk -F': ' '/^\\ *Chipset Model:/ {printf $2 \", \"}'")) ?? "INTEL!"
        gpu.removeLast(2)
        print("Detected GPU: \(gpu)")
        cpu = (try? call("sysctl -n machdep.cpu.brand_string")) ?? "INTEL!"
        print("Detected CPU: \(cpu)")
        systemVersion = (try? call("sw_vers -productVersion")) ?? "11.xx.yy"
        print("Detected System Version: \(systemVersion)")
    }
}

extension Color {
    init(
        r red: Int,
        g green: Int,
        b blue: Int,
        o opacity: Double = 1
    ) {
        self.init(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: opacity
        )
    }
}

struct SideImageView: View {
    let releaseTrack: String
    let scale: CGFloat
    var body: some View {
        if releaseTrack == "Public Beta" {
            Image("BigSurLake")
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: scale)
                .padding()
        } else if releaseTrack == "Developer" {
            Image("BigSurSideShot")
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: scale)
                .padding()
        } else if releaseTrack == "Release" {
            Image("BigSurSafari")
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: scale)
                .padding()
        }
    }
    
    init(releaseTrack: String, scale: CGFloat = 145) {
        self.releaseTrack = releaseTrack
        self.scale = scale
    }
}

struct BackGradientView: View {
    @Environment(\.colorScheme) var colorScheme
    let releaseTrack: String
    var body: some View {
        if releaseTrack == "Public Beta" {
            LinearGradient(gradient: .init(colors: [.init(r: 196, g: 0, b: 255), .init(r: 117, g: 0, b: 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(colorScheme == .dark ? 0.7 : 0.96)
        } else if releaseTrack == "Developer" {
            LinearGradient(gradient: .init(colors: [.init(r: 237, g: 36, b: 5), .init(r: 254, g: 110, b: 16)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .opacity(colorScheme == .dark ? 0.5 : 0.96)
        } else if releaseTrack == "Release" {
            LinearGradient(gradient: .init(colors: [.init(r: 0, g: 220, b: 239), .init(r: 5, g: 229, b: 136)]), startPoint: .leading, endPoint: .trailing)
                .opacity(colorScheme == .dark ? 0.7 : 0.96)
                .background(Color.black)
        }
    }
}
