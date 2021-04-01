![Patched Sur](https://raw.githubusercontent.com/BenSova/Patched-Sur/main/Extra%20Files/banner.png)

## What is Patched Sur?

Patched Sur is a UI patcher for macOS Big Sur, designed to make it easy to run macOS 11 on unsupported Macs. This patcher hopes to allow any user of any knowledge to patch their Mac, while still giving you freedom on how you want to use your Mac.

## Compatibility
To see if your Mac is supported [click here](https://bensova.gitbook.io/big-sur/supported-macs).

## FileVault Warning 
**You must Turn FileVault Off before using Patched Sur**

The patcher shouldn't let you upgrade anyway, but it's good to make sure it's off.

## How do I use Patched Sur?

**1.** Download Patched Sur, (.dmg not .zip), from the GitHub releases page.

**2.** Open the dmg file, right click on the app, and click open.

**3.** The first three prompts are just information explaining the following:
   - A quick intro into Patched Sur
   - How much functionality you will get out of macOS once the patching process is complete
   - How the patcher works, and what it does to your Mac

**4.** Next, you can choose what update track you would like to update with. `Release` is the default, but you can also choose `Public Beta` and `Developer Beta` if you want one of the beta tracks. (Note: Apple does not always release InstallAssistant.pkgs for the beta tracks, this means you might be unable to get certain betas.)

**5.** Then, you can select whether you want to update macOS from Catalina to Big Sur (or Big Sur to Big Sur if you are switching from a different patcher) or do a clean install of Big Sur (currently unavailable).

**6.** After that, your Mac will start downloading **@barrykn**'s micropatcher for kexts and a couple other resources.

**7.** Now, you will be able to choose what version of macOS to download. By default it will show the latest version based on your selected release track, but if you click `View Other Versions`, you can choose a different one or your own.

**8.** Once the download is finished, you need to enter your password, so Patched Sur can install the package. Then, after you select the USB drive you want to use to install macOS, the patcher can copy the installer onto the USB.

**9.** Finally, the USB gets patched and you are ready to start installation!

**10.** Reboot your computer, but immediately start holding down the `Option/Alt` key as soon as your Mac turns on.

**11.** Select the __yellow__ EFI Boot drive, (if there are multiple unplug and replug in your drive and select the EFI Boot that disappeared and reappeared).  Then, your Mac will quickly turn off, so turn it back on while, again, holding down `Option/Alt`. Then, select Install macOS Big Sur.

**12.** Once the installer boots, select reinstall macOS and agree to the Terms and Conditions. Then, select the drive you want to install Big Sur onto, (it should be the same drive you ran the patcher on).

**13.** After the installer is done, (it will take a while and appear to get stuck), log in to your Mac and open Patched Sur from your Applications folder or LaunchPad.

**14.** Open the Patch Kexts section and enter your password. Then, you should be able to reboot and enjoy Big Sur!

#### How do I choose a my own installer?

To choose a different installer that you already have downloaded, click `View Other Versions`. Then, click `Find an Installer` and navigate to the InstallAssistant.pkg or Install macOS Big Sur.app file you would like to use.

#### How would I update macOS? (Starting in v0.1.0+)

To update macOS, follow the steps below.

**1.** Launch the post-install app and click `Update macOS`.

**2.** Select the version you want to update to, (the latest version should be pre-selected).

**3.** Once it finishes downloading the package, it will prompt you to install which will restart your computer after a little bit.

**4.** After the update finishes, open the post install app and patch your kexts.

**5.** Enjoy the latest version of macOS!

Note: Apple does not always release InstallAssistant.pkgs for the beta tracks and some minor updates, this means you might be unable to get certain upates.

## Support

I am a living, breathing human, so don't expect me to respond right away to everything. However, if you need support with the patcher, feel free to open an issue or discussion here (please search the issue list before making a new one) or use one of the links below!

[r/BigSurPatcher Subreddit](https://www.reddit.com/r/BigSurPatcher/)

[Unsupported Macs Discord](https://discord.com/invite/XbbWAsE) (#bensova-patcher)
