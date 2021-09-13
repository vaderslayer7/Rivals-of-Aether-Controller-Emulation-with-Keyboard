# B0XX-AHK

b0xx-ahk is an Autohotkey script emulating B0XX behavior through a keyboard within Dolphin. It is an adaptation of a [similar script](https://github.com/tlandegger/smashbox-AHK) for Smashbox created by tlandegger.

The B0XX functionality provided is *incomplete*. Missing behavior includes:

* Pivot utilt/angled ftilt nerf
* SDI nerf

I am unaffiliated with the creators/producers of the B0XX. 

# Requirements

1. Windows. Autohotkey does not run on other platforms unfortunately. This script has been tested on Windows 10.
2. Keyboard with high n-key rollover. N-key rollover determines how many keys can be pressed simultaneously. Most gaming and mechanical keyboards are sufficient in this respect, while most laptop and non-gaming keyboards are not. Some non-gaming keyboards may also allow sufficient simultaneous key presses for only certain keys. Use something like www.keyboardchecker.com to check the behavior of yours.
3. Dolphin. Slippi 2.0.3+ and Faster Melee 5.9F have been tested, other Dolphin versions will probably work as well.
4. vJoy, a joystick emulator. Download and installation instructions are provided under Setup below. 

# Setup

1. Download vJoy from https://sourceforge.net/projects/vjoystick/?source=typ_redirect. After installing, run "Configure vJoy" (can be found by searching in the start menu). Set the number of buttons to 12 and hit apply.
2. Place the b0xx-keyboard.ini file inside the \<YourDolphinInstallation\>\User\Config\Profiles\GCPad folder, creating any subfolders that do not already exist. If you're using SmashLadder Dolphin Launcher, your Dolphin instances might be in C:\Users\\\<YourUsername\>\AppData\Roaming\SmashLadder Dolphin Launcher\dolphin_downloads.
3. In Dolphin, open up the controller config. Set player 1 to Standard Controller, then hit configure. Under Profile, select b0xx-keyboard and hit load. Verify that Device is set to DInput/0/vJoy. Hit OK.
4. Place the b0xx.exe and hotkeys.ini files from this repo in the same directory on your computer. Run b0xx.exe.

# Configuration

All keybindings are configurable in the GUI. To open it, find the Autohotkey icon in the task bar hidden icons (lil ^ symbol in the system tray lower right -> green H icon) and left click or right click followed by "Edit Controls". Hotkeys can also be edited in hotkeys.ini directly. Changes made in the GUI are immediately saved/reflected in to hotkeys.ini and vice versa.

The default Windows behavior of any keys used can be disabled in the GUI. This is recommended for any meta-keys or keys with system functionality (e.g. shift, ctrl, tab, esc). To disable default behavior, check the "Prevent Default Behavior" box in the GUI next to the appropriate hotkey.

## Using Shift, Control, and Alt

The GUI allows you to bind a hotkey to a meta-key combination such as Shift + W. To bind a hotkey to one of the meta-keys by itself, you must edit hotkeys.ini directly and enter either "Shift", "Ctrl", or "Alt" for the value on the appropriate line. To enter a meta-key combination in hotkeys.ini, precede the appropriate value with "+", "^", or "!" for Shift/Ctrl/Alt respectively (e.g., for Shift + W, enter "+w" in hotkeys.ini).

## hotkeys.ini Index

The numbered lines in hotkeys.ini correspond to the following buttons:

1. Analog Up
2. Analog Down
3. Analog Left
4. Analog Right
5. ModX
6. ModY
7. A
8. B
9. L
10. R
11. X
12. Y
13. Z
14. C-Up
15. C-Down
16. C-Left
17. C-Right
18. Light Shield
19. Mid Shield
20. Start
21. D-Up
22. D-Down
23. D-Left
24. D-Right
25. Debug

# Default Controls

The [default layout](https://raw.githubusercontent.com/agirardeau/b0xx-ahk/master/default-layout.jpg) is chosen to avoid keys that would interfere with normal computer usage (ctrl, tab, enter, etc) or are not present on all keyboards (numpad, F-keys), as well as to work passably on keyboards with poor n-key rollover properties. You can probably find a better layout for you by using additional keys and taking into account your particular hands and keyboard. Some community-sourced suggestions are provided [here](https://raw.githubusercontent.com/agirardeau/b0xx-ahk/master/suggested-layouts.png).

Ctrl-Alt-S pauses and unpauses the Autohotkey script.

# Troubleshooting

For general assistance with installation and setup, check out the B0XX discord (link can be found on [b0xx.com](b0xx.com)). People there are pretty friendly and there's usually
someone around who can help.

## Error: "\<key\>" is not a valid key name

One of the entries in hotkeys.ini is invalid. Find the line referenced in the error message and set it to something valid.

Some people may get this error despite not having made an invalid change to hotkeys.ini, due to the default value of the debug hotkey being the empty string. If there is no key value between the quotes in the error message, open hotkeys and add a value for the debug hotkey (entry #25).

## Controller behavior is unexpected, or a specific technique doesn't work

* Use www.keyboardchecker.com to make sure all of the required keyboard inputs can be recorded simultaneously on your keyboard.
* Make sure any keys like Shift, Control, Tab, etc have their default behavior disabled in the GUI.
* Try restarting the Autohotkey script.
* In 20XX (or similar), enter debug mode (Start + D-Pad right twice) and turn on controller display (Y + D-Pad left) and analog stick coordinate display (X + D-Pad right, purple numbers). Check whether the expected inputs are being passed from Autohotkey to Melee.
* Use the GUI to add a "debug" hotkey, hold down the keys related to your technique, and press debug. The dialog box that appears will tell you whether the script is actually seeing all of your button presses.
* Hmu (TuberLuber on Discord/Reddit) or file an issue on Github.

## Holding left and right continuously causes the character to dashdance, or up and down causes the character to repeatedly jump/fastfall

This is an issue with your keyboard or keyboard driver, since Autohotkey only updates controller inputs when a key is first held or released.

## Holding C-Left and pressing C-Right should cause a rightward smash/aerial, but it doesn't

This is a glitch in melee itself, see: https://imgur.com/a/Tf3eKJQ

# Development Info

## Requirements

1. Install Autohotkey from https://autohotkey.com/.
2. Install AHK-CvJoyInterface, a library for linking Autohotkey and vJoy. Download CvJoyInterface.ahk from https://github.com/evilC/AHK-CvJoyInterface and place it inside Autohotkey's Lib folder (for me this was located at C:\Program Files\AutoHotkey\Lib). Create the Lib folder if it does not already exist. 

## General

After making changes to b0xx.ahk, recompile b0xx.exe by right-clicking b0xx.ahk and selecting "Compile Script." Autohotkey must be installed.
