//
//  MacCompatibility.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct MacCompatibility: View {
    @Binding var p: Int
    @State var hovered = nil as String?
    @State var info: CompatInfo?
    @State var progress2 = VerifyProgess.downloading
    @State var problems: [ProblemInfo] = []
    @State var known = [] as [Substring]
    @State var alert: Alert?
    var body: some View {
        VStack {
            ZStack {
                Text("Mac Compatibility").bold()
                HStack {
                    Button {
                        if progress2 == .clean {
                            withAnimation {
                                p = 0
                            }
                        }
                    } label: {
                        ZStack {
                            (hovered != "BACK" && (progress2 == .clean || progress2 == .issues || progress2 == .noCompat) ? Color.secondary : Color.secondary.opacity(0.7))
                                .cornerRadius(10)
                                .onHover(perform: { hovering in
                                    if progress2 == .clean || progress2 == .issues || progress2 == .noCompat {
                                        hovered = hovering ? "BACK" : nil
                                    }
                                })
                            HStack(spacing: 3) {
//                                if #available(OSX 11.0, *) {
//                                    Image(systemName: "chevron.left.circle")
//                                        .font(.body)
//                                }
                                Text("Back")
                            }.font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 4)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading, 15)
                    Spacer()
                    Button {
//                        withAnimation {
                            if progress2 == .clean || progress2 == .noCompat {
                                withAnimation {
                                    p = 2
                                }
                            } else if progress2 == .issues {
                                if problems.map({ $0.type }).contains("Fatal") {
                                    alert = .init(title: Text("Fatal Errors Were Detected"), message: Text("There are some errors that were detected that could cause huge problems with Big Sur. Please resolve them if you can, otherwise you will not be able to install Big Sur."), dismissButton: .cancel(Text("Okay")))
                                } else {
                                    alert = .init(title: Text("Some Possible Problems Were Detected"), message: Text("There are some problems that were detected that might cause some problems with Big Sur. While you could be fine, it's best to resolve as many of these as you can before starting installation."), primaryButton: .default(Text("Continue"), action: { progress2 = info != nil ? .clean : .noCompat }), secondaryButton: .cancel())
                                }
                            }
//                        }
                    } label: {
                        ZStack {
                            (hovered != "CONTINUE" && (progress2 == .clean || progress2 == .issues || progress2 == .noCompat) ? Color.accentColor : Color.accentColor.opacity(0.7))
                                .cornerRadius(10)
                                .onHover(perform: { hovering in
                                    if progress2 == .clean || progress2 == .issues || progress2 == .noCompat {
                                        hovered = hovering ? "CONTINUE" : nil
                                    }
                                })
                            HStack(spacing: 3) {
                                Text(progress2 == .clean ? "Continue" : "Next")
//                                if #available(OSX 11.0, *) {
//                                    Image(systemName: "chevron.right.circle")
//                                        .font(.body)
//                                }
                            }.font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 4)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.trailing, 15)
                }
            }.padding(.top, 15)
            Spacer()
            if progress2 == .clean {
                Text(info!.macName)
                    .font(.system(size: 17)).bold()
                HStack(spacing: 1) {
                    Text("Reported by: ")
                    ZStack {
                        if known.contains(Substring(info!.author)) {
                            Rectangle()
                                .foregroundColor(.green)
                                .cornerRadius(10)
                        }
                        HStack(spacing: 1) {
                            Text(info!.author).bold()
//                            if known.contains(Substring(info!.author)), #available(OSX 11.0, *) {
//                                Image(systemName: "checkmark.seal.fill")
//                                    .font(.system(size: 10))
//                                    .help("This report was written by an trusted member of the patching community.")
//                            }
                        }.foregroundColor(known.contains(Substring(info!.author)) ? .white : .primary)
                        .padding(known.contains(Substring(info!.author)) ? 1 : 0)
                        .padding(.horizontal, known.contains(Substring(info!.author)) ? 2 : 0)
                    }.fixedSize()
                    if info!.approved.count > 0 {
                        Text(" (\(info!.approved.count) \(info!.approved.count == 1 ? "person" : "others") approve\(info!.approved.count == 1 ? "s" : ""))")
                    }
                }.font(.system(size: 11))
                Text(info!.details)
                    .padding(5)
                    .padding(.horizontal, 5)
                    .multilineTextAlignment(.center)
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.works, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.unknown, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 11.5))
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(info!.warns, id: \.self) { item in
                            HStack {
                                Rectangle()
                                    .foregroundColor(.red)
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(10)
                                Text(item)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
            } else if progress2 == .noCompat {
                Text("Unable to find the compatability report for your model. Your Mac will probably work assuming that this feature is new and not many people have contributed yet. However, you can still try it and if you do, please contribute your results, it's not that hard and well help more people in the future!")
                    .padding()
                    .multilineTextAlignment(.center)
            } else if progress2 == .issues {
                Text("Uh-oh! Patched Sur detected some problems that might interfere with your ability to use this patcher, and the experiences that will come with it! Please resolve as many of these issues as you can, but remember some may not be solvable.")
                    .padding()
                    .multilineTextAlignment(.center)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(problems, id: \.title) { problem in
                            HStack {
                                Image(problem.type == "Fatal" ? "Fatal2" : "Warn2")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .offset(y: -0.75)
                                VStack(alignment: .leading) {
                                    Text(problem.title)
                                        .bold()
                                    Text(problem.problemInfoDescription)
                                        .font(.system(size: 10))
                                        .lineLimit(3)
                                }
                            }.padding(.horizontal)
                        }
                    }
                }.padding(.bottom)
            } else {
                Text("Verifing Mac")
                    .bold()
                Text("This first step is esentail to how realiable Patched Sur is. This step tries to detect as many problems caused as possible before running into them. This includes FileVault, Fusion Drives and many other problems.")
                    .padding()
                    .multilineTextAlignment(.center)
                VerifierProgressBar(progress2: $progress2, info: $info, problems: $problems, known: $known)
            }
            Spacer()
        }.alert(isPresented: .init(get: { alert != nil }, set: { _ in
            alert = nil
        }), content: {
            alert!
        })
    }
}

enum VerifyProgess {
    case downloading
    case verifing
    case issues
    case clean
    case noCompat
    case errored
}

struct VerifierProgressBar: View {
    @State var progress = CGFloat(0)
    @Binding var progress2: VerifyProgess
    @Binding var info: CompatInfo?
    @Binding var problems: [ProblemInfo]
    @Binding var known: [Substring]
    @State var errorX = "Uh-oh, Something went wrong."
    var body: some View {
        ZStack {
            ProgressBar(value: $progress, length: 200)
            switch progress2 {
            case .downloading:
                Text("Fetching Details...")
                    .foregroundColor(.white)
                    .padding(7)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            _ = try? shellOut(to: "mkdir ~/.patched-sur")
                            var macModel = ""
                            do {
                                macModel = try shellOut(to: "sysctl -n hw.model")
                            } catch {
                                progress2 = VerifyProgess.errored
                                errorX = "Failed to detect Mac Model\n\(error.localizedDescription)"
                                return
                            }
                            progress = CGFloat(0.01)
                            print("Detected model:" + macModel)
                            print("Downloading model details from: https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")
                            do {
                                info = try CompatInfo(fromURL: URL(string: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/Compatibility/\(macModel.replacingOccurrences(of: ",", with: "%2C")).json")!)
                            } catch {
                                print("Failed to fetch Mac Model compatability report... Assuming it doesn't exist!")
                            }
                            progress = CGFloat(0.25)
                            do {
                                _ = try? shellOut(to: "rm -rf ~/.patched-sur/DetectProblems.sh")
                                try shellOut(to: "curl -o DetectProblems.sh https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/DetectProblems.sh", at: "~/.patched-sur")
                                try shellOut(to: "chmod u+x ~/.patched-sur/DetectProblems.sh")
                            } catch {
                                progress2 = VerifyProgess.errored
                                errorX = "Failed to download possible problems.\n\(error.localizedDescription)"
                                return
                            }
                            progress = CGFloat(0.5)
                            if info != nil {
                                do {
                                    known = try String(contentsOf: "https://raw.githubusercontent.com/BenSova/Patched-Sur-Compatibility/main/KnownContributors").split(separator: "\n")
                                } catch {
                                    known = ["BenSova"]
                                    print("Failed to find known contibutors, skipping this step.")
                                }
                            }
                            progress = CGFloat(0.55)
                            progress2 = .verifing
                        }
                    }
            case .verifing:
                Text("Verifing Mac...")
                    .foregroundColor(.white)
                    .padding(7)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            do {
                                let problemsToBe = try shellOut(to: "~/.patched-sur/DetectProblems.sh")
                                problemsToBe.split(separator: "\n").forEach { problem in
                                    let details = problem.split(separator: ";")
                                    guard details.count == 3 else {
                                        if problem != "\n" {
                                            print("Invalid check! Please report this to @BenSova as soon as possible!")
                                            print("Include this in your message:")
                                            print(problem)
                                        }
                                        return
                                    }
                                    let detectedProblem = ProblemInfo(title: String(details[1]), problemInfoDescription: String(details[2]), type: String(details[0]))
                                    problems.append(detectedProblem)
                                }
                                if problems.count > 0 {
                                    progress2 = .issues
                                } else {
                                    progress2 = info != nil ? .clean : .noCompat
                                }
                            } catch {
                                progress2 = .errored
                                errorX = error.localizedDescription
                            }
                        }
                    }
            case .issues:
                Text("Detected issues! Redirecting.")
            default:
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(errorX, forType: .string)
                } label: {
                    Text(errorX)
                        .foregroundColor(.white)
                        .padding(7)
                }.buttonStyle(BorderedButtonStyle())
            }
        }.fixedSize(horizontal: false, vertical: true)
        .frame(width: 200)
    }
}

extension Array where Element : Equatable {
    func contains(oneOf: [Element]) -> Bool {
        var result = false
        forEach { item in
            result = result ? true : oneOf.contains(item)
        }
        return result
    }
}

/*
 Error 1x2
 2021-01-18 22:31:31.190831-0700 fdesetup[3384:124769] [ManagedClient] fdesetup: command = status
 2021-01-18 22:31:31.272683-0700 fdesetup[3384:124769] [ManagedClient] fdesetup: no user approved profile was passed
 2021-01-18 22:31:31.272714-0700 fdesetup[3384:124769] [ManagedClient] fdesetup:: status
 /Users/bensova/.patched-sur/DetectProblems.sh: line 130: syntax error: unexpected end of file
 */
