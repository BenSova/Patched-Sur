//
//  PatchKextsActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/3/21.
//

import Foundation

// MARK: Detect Patches

func detectPatches(installerName: (String?) -> (), legacy: (Bool) -> ()) {
    
    // Detect Patched-Sur-Patches
    print("Checking for USB at \"/Volumes/Install macOS Big Sur Beta/KextPatches\"...")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/KextPatches' ]]")) != nil {
        print("Found PSPatches at Beta path")
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        return
    }
    print("Checking for USB at \"/Volumes/Install macOS Big Sur/KextPatches\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/KextPatches' ]]")) != nil {
        print("Found PSPatches at Regular path")
        installerName("'/Volumes/Install macOS Big Sur'")
        return
    }
    print("Checking for kexts at \"/usr/local/lib/Patched-Sur-Patches/KextPatches")
    if (try? call("[[ -d /usr/local/lib/Patched-Sur-Patches/KextPatches ]]")) != nil {
        print("Found pre-downloaded kexts!")
        installerName("/usr/local/lib/Patched-Sur-Patches/Scripts")
//        installerName(nil)
        return
    }
    
    // Detect micropatcher (Legacy)
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur Beta/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur Beta/kexts' ]]")) != nil {
        print("Found micropatcher at legacy Beta path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur Beta'")
        legacy(true)
        return
    }
    print("Checking for micropatcher kexts at \"/Volumes/Install macOS Big Sur/kexts\"")
    if (try? call("[[ -d '/Volumes/Install macOS Big Sur/kexts' ]]")) != nil {
        print("Found micropatcher at legacy regular path")
        print("It is! This will be used even though it is the last resort.")
        installerName("'/Volumes/Install macOS Big Sur'")
        legacy(true)
        return
    }
    print("Checking for micropatcher kexts at \"~/.patched-sur/big-sur-micropatcher/payloads/kexts\"")
    if (try? call("[[ -d ~/.patched-sur/big-sur-micropatcher/payloads/kexts ]]")) != nil {
        print("Found micropatcher at legacy pre-downloaded path")
        print("Confirming this is Ben's fork")
        if (try? call("cat ~/.patched-sur/big-sur-micropatcher/payloads/patch-kexts.sh | grep \".patched-sur/big-sur-micropatcher/payloads\"")) != nil {
            print("It is! This will be used even though it is the last resort.")
            installerName("~/.patched-sur/big-sur-micropatcher/payloads")
            legacy(true)
            return
        }
    }
    installerName(nil)
}

func patchKexts(password: String, legacy: Bool, location: String, errorX: (String?) -> ()) {
    print("Starting Patch Kexts")
    do {
        if legacy {
            print("Warning: Starting legacy patch kexts mode.")
            print("These patches haven't really been updated since a long time ago.")
            let output = try call("\(location)/patch-kexts.sh", p: password)
            UserDefaults.standard.setValue("Warning: Legacy Patch Kexts Mode was used.\n" + output, forKey: "PatchKextsLastRun")
        } else {
            let output = try call("\(location)/PatchKexts.sh", p: password)
            UserDefaults.standard.setValue(output, forKey: "PatchKextsLastRun")
        }
        errorX(nil)
    } catch {
        let log = (legacy ? "Warning: Legacy Patch Kexts Mode was used.\n" : "") + error.localizedDescription
        errorX(log)
    }
}
