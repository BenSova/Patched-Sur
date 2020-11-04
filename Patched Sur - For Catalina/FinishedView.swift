//
//  FinishedView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/18/20.
//

import SwiftUI

struct FinishedView: View {
    var body: some View {
        VStack {
            Text("Finished!").bold()
            Text("The patcher has finished running! You can now boot into the USB (hold option as soon as your Mac turns on and select the yellow disk), then you can run the installer like normal. It does say \"Reinstall macOS\" but that only replaces the system data, not your data. Once that finishes, you can patch your kexts with the post install app that is now in your Applications folder.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView()
    }
}
