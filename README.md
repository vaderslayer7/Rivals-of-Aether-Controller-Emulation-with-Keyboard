# B0XX-AHK

b0xx-ahk is an Autohotkey script emulating B0XX behavior through a keyboard within Dolphin. It is an adaptation of a [similar script](https://github.com/tlandegger/smashbox-AHK) for Smashbox created by tlandegger.

The B0XX functionality provided is currently *incomplete*. Missing behavior includes:

* Pivot utilt/angled ftilt nerf
* SDI nerf

I am unaffiliated with the creators/producers of the B0XX. 

# Requirements
1. Windows. Autohotkey does not run on other platforms unfortunately. This script has been tested on Windows 10.
2. A keyboard with high n-key rollover. N-key rollover determines how many keys can be pressed simultaneously. Most gaming and mechanical keyboards are sufficient in this respect, while most laptop and non-gaming keyboards are not. Some non-gaming keyboards may also allow sufficient simultaneous key presses for only certain keys. Use something like www.keyboardchecker.com to check the behavior of yours.
3. Dolphin. Slippi 2.0.3+ and Faster Melee 5.9F have been tested, other Dolphin versions will probably work as well.
4. vJoy, a joystick emulator. Download and installation instructions are provided under Setup below. 
5. (Optional - for development) Autohotkey. This is a scripting language for creating keybindings. Download the installer at https://autohotkey.com/.
6. (Optional - for development) AHK-CvJoyInterface, a library for linking Autohotkey and vJoy. Download CvJoyInterface.ahk from https://github.com/evilC/AHK-CvJoyInterface and place it inside Autohotkey's Lib folder (for me this was located at C:\Program Files\AutoHotkey\Lib). You may have to create the Lib folder if it does not already exist. 

# Setup
1. Download vJoy from https://sourceforge.net/projects/vjoystick/?source=typ_redirect. After installing, run "Configure vJoy" (can be found by searching in the start menu). Set the number of buttons to 12 and hit apply.
2. Place the b0xx-keyboard.ini file inside the \<YourDolphinInstallation\>\User\Config\Profiles\GCPad folder (create any folders that do not already exist. If you're using SmashLadder Dolphin Launcher, your Dolphin instances may be installed to C:\Users\Your-Username\AppData\Roaming\SmashLadder Dolphin Launcher\dolphin_downloads).
3. In Dolphin, open up the controller config. Set player 1 to Standard Controller, then hit configure. Under Profile, select b0xx-keyboard and hit load. Verify that Device is set to DInput/0/vJoy. Hit OK.
4. Run b0xx.exe. Make sure the hotkeys.ini file is in the same directory.

# Configuration

All keybindings are configurable. To change, open the GUI by finding the Autohotkey script icon in the task bar hidden icons (lil ^ symbol in the system tray lower right -> green H icon (left click, or right click -> "Edit Controls")). Alternatively they can be edited by modifying the hotkeys.ini file directly. Changes made in the GUI are automatically saved to hotkeys.ini and reflected in real time.

The GUI can be used to disable the default behavior of any of the keys used. This is highly recommended for any metakeys or other keys with Windows functionality (Shift, Ctrl, Tab, Esc, etc). To disable default behavior, check the "Prevent Default Behavior" box in the GUI next to the appropriate hotkey.

# Default Controls

The [default layout](https://github.com/agirardeau/b0xx-ahk/blob/master/default-layout.jpg) is chosen to avoid keys that would interfere with normal computer usage (control, tab, enter, etc) or are not present on all keyboards (numpad, F-keys), as well as to work passably on some keyboards with poor n-key rollover properties. Making use of those keys, as well as taking into account the characteristics of your particular hands and keyboard, will probably allow you to find a better layout for yourself. Some community-sourced suggestions are provided [here](https://github.com/agirardeau/b0xx-ahk/blob/master/suggested-layouts.png).

Ctrl-Alt-S pauses and unpauses the Autohotkey script.

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
This looks like it might be a glitch in melee itself. See: https://imgur.com/a/Tf3eKJQ

# Development Info

After making changes to b0xx.ahk, recompile b0xx.exe by right-clicking b0xx.ahk and selecting "Compile Script." This requires Autohotkey to be installed.
