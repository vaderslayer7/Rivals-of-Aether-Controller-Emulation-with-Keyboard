# B0XX-AHK

This is an Autohotkey script that lets you set up your keyboard to act like the B0XX in Dolphin. It is an adaptation of a [similar script](github.com/tlandegger/smashbox-AHK) for simulating Smashbox on Dolphin created by tlandegger.

The script uses Autohotkey to read keyboard inputs and convert them to inputs to a virtual joystick called vJoy, which is used as a controller by Dolphin.

The B0XX functionality provided is currently *incomplete*. Missing behavior includes:

* SDI nerf
* Pivot utilt/angled ftilt nerf
* B0XX r2 lightshield buttons

I am unaffiliated with the creators/producers of the B0XX. 

# Requirments
1. Windows. Autohotkey does not run on other platforms unfortunately. This script has been tested on Windows 10.
2. Dolphin. Slippi 2.0.1+ and Faster Melee 5.9F have been tested, other Dolphin versions probably work as well.
3. A keyboard with high n-key rollover. This is how many keys can be pressed at the same time without errors. Most gaming and mechanical keyboards will allow at least 6 keys which should be enough for every advanced technique. Note that some non-gaming keyboards might allow a large number of simultaneous key presses for only some combinations of keys. Use something like www.keyboardchecker.com to check the behavior of yours.
4. vJoy: A joystick emulator. Download and install from https://sourceforge.net/projects/vjoystick/?source=typ_redirect. After installing, run "Configure vJoy" (can be found by searching in the start menu). Set the number of buttons to 16 and hit apply.
5. (Optional - for development) Autohotkey. This is a scripting language for remapping keyboard keys. Download the installer at https://autohotkey.com/.
6. (Optional - for development) AHK-CvJoyInterface: a library for linking Autohotkey and vJoy. Download CvJoyInterface.ahk from https://github.com/evilC/AHK-CvJoyInterface and place it inside the Lib folder where you installed Autohotkey (for me C:\Program Files\AutoHotkey\Lib). You may have to create the Lib folder if it is not already there. 

# Setup
1. Place the b0xx-keyboard.ini file inside the \<YourDolphinInstallation\>\User\Config\Profiles\GCPad folder (create any folders that do not already exist. If you're using SmashLadder Dolphin Launcher, your Dolphin instances may be installed to C:\Users\Your-Username\AppData\Roaming\SmashLadder Dolphin Launcher\dolphin_downloads).
2. In Dolphin, open up controller config. Set player 1 to Standard Controller, then hit configure. Under Profile, select b0xx-keyboard and hit load. Verify that Device is set to DInput/0/vJoy. Hit OK.
3. Run b0xx.exe. Make sure the hotkeys.ini file is in the same directory.

# Configuration

The Autohotkey script can be configured to change the keybindings. Open the GUI by finding the Autohotkey script in the task bar hidden icons (lil ^ icon in lower right -> green H icon (left click, or right click -> "Edit Controls")). Alternatively they can be edited by modifying the hotkeys.ini file directly. Changes made in the GUI are automatically saved to the appropriate files and reflected in real time.

The GUI can be used to disable the default behavior of any of the keys used. This is highly recommended for any metakeys or other keys with Windows functionality (Shift, Ctrl, Tab, Esc, etc).

# Default Controls
* W/E/R: Left/Down/Right
* [: Up
* C/V: ModX/ModY
* Q: L
* 7: R
* O/9: X/Y
* P: Z
* M: A
* I: B
* K/Space/N/,: C Up/Down/Left/Right
* Arrow Keys: D-Pad (for convenience. D-Pad is also available via ModX + ModY + C as on an actual B0XX)
* 6: Start
* Pause / Ctrl-Alt-S: Pause or unpause the Autohotkey script

# Troubleshooting

## Controller behavior is unexpected, or a specific technique doesn't work
* Use www.keyboardchecker.com to make sure all of the required keyboard inputs can be recorded simultaneously on your keyboard.
* Make sure any keys like Shift, Control, Tab, etc have their default behavior disabled in the GUI.
* Try restarting the Autohotkey script.
* In 20XX (or similar), enter debug mode (Start + D-Pad right twice) and turn on controller display (Y + D-Pad left) and analog stick coordinate display (X + D-Pad right, purple numbers). Check whether the expected inputs are being passed from Autohotkey to Melee.
* Use the GUI to add a "debug" hotkey, hold down the keys related to you technique, and press debug. The dialog box that appears will tell you whether the script is actually seeing all of your button presses.
* Hmu (TuberLuber on Discord/Reddit) or file an issue on Github.

## Holding left and right continuously causes the character to dashdance, or up and down causes the character to repeatedly jump/fastfall
This is an issue with your keyboard or keyboard driver, Autohotkey will only update controller inputs when a key is first held or released.

## Holding C-Left and pressing C-Right should cause a rightward smash/aerial, but it doesn't
This looks like it might be a glitch in melee itself. Check out: https://imgur.com/a/Tf3eKJQ

# Development Info

After making changes to b0xx.ahk, recompile b0xx.exe by right-clicking b0xx.ahk and selecting "Compile Script." This requires Autohotkey to be installed.
