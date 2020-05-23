# B0XX-AHK

This is an Autohotkey script that lets you set up your keyboard to act like the B0XX in Dolphin. It is an adaptation of a similar script for simulating Smashbox on Dolphin created by tlandegger.

The script uses Autohotkey to read keyboard inputs and convert them to inputs to a virtual joystick called vJoy, which is used as a controller by Dolphin.

The B0XX functionality provided is *incomplete*. Missing behavior includes:

* Firefox angles other than 0-21-45-69-90°
* SDI nerf
* Pivot utilt/angled ftilt nerf
* B0XX r2 lightshield buttons

I am unaffiliated with the creators/producers of the B0XX. 

# Requirments
1. Windows. Autohotkey only works on Windows. This script was tested on Windows 10.
2. Faster Melee 5.9F. Other Dolphin versions might also work but have not been tested.
3. A keyboard with high n-key rollover. This is how many keys can be pressed at the same time without errors. Most gaming and mechanical keyboards will allow at least 6 keys which should be enough for every advanced technique. Note that some non-gaming keyboards might allow large numbers of simultaneous key presses for only some combinations of keys - use something like www.keyboardchecker.com to check yours.
4. vJoy: A joystick emulator. Download and install from https://sourceforge.net/projects/vjoystick/?source=typ_redirect. After installing, run "Configure vJoy" (can be found by searching in the start menu). Set the number of buttons to 16 and hit apply.
5. (Optional - for development) Autohotkey. This is a scripting language for remapping keyboard keys. Download the installer at https://autohotkey.com/.
6. (Optional - for development) AHK-CvJoyInterface: a library for linking Autohotkey and vJoy. Download CvJoyInterface.ahk from https://github.com/evilC/AHK-CvJoyInterface and place it inside the Lib folder where you installed Autohotkey (for me C:\Program Files\AutoHotkey\Lib). You may have to create the Lib folder if it is not already there. 

# Setup
1. Place the b0xx-keyboard.ini file inside the Dolphin-Installation-Folder\User\Config\Profiles\GCPad folder (create the Profiles/GCPad folder if it does not already exist. If you're using SmashLadder Dolphin Launcher your Dolphin instances maybe installed to C:\Users\Your-Username\AppData\Roaming\SmashLadder Dolphin Launcher\dolphin_downloads).
2. In Dolphin, open up controller config. Set player 1 to a standard controller, then hit configure. Under profile, select b0xx-keyboard and hit load. After, set device to vJoy. Then hit OK.
3. Run b0xx.exe. Make sure the hotkeys.ini and parameters.ini files are in the same directory.

# Configuration

The Autohotkey script can be configured to change the keybindings and to adjust analog stick scale/offset values. Both of these can be edited in a GUI by finding the Autohotkey script in the task bar hidden icons (lil ^ icon in lower right -> green H icon (left click, or right click -> "Edit Controls")). Alternately they can be edited by modifying the hotkeys.ini and parameters.ini files directly. Changes made in the GUI are automatically saved to the appropriate files and reflected in realtime.

The default scale and offset values should work fine, but may need to be adjusted if you run into issues. Common manifestations of mis-tuned scaling/offset are failed shield drop, missing airdodge/firefox angles, and incorrect tilt/smash. To check this, enter debug mode in 20XX (Start + D-Right + D-Right) and turn on the analog stick display with X + D-Right. Compare the analog stick values with those provided in the B0XX melee manual. I find that the vJoy vertical axis tends to shift by +/- 0.0375 over time for reasons I do not understand - this means that the vertical offset value has to be adjusted fairly often unfortunately.

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
* J/Space/N/K: C Up/Down/Left/Right
* Arrow Keys: D-Pad (for convenience. D-Pad is also available via ModX + ModY + C as on an actual B0XX)
* 6: Start
* Pause / Ctrl-Alt-S: Pause or unpause the Autohotkey script

# Troubleshooting

## A Specific Technique Doesn't Work
* Use www.keyboardchecker.com to make sure all of the required keyboard inputs can be recorded simultaneously on your keyboard.
* Use 20XX to check that the analog stick coordinates the game sees are what you expect, and adjust the scale/offset parameters appropriately.
* If neither of the above work, feel free to hmu or file an issue on github.

# Development info

b0xx.exe is a compiled version of the b0xx.ahk file with the vjoy autohotkey library in as well. If you want to make changes to the script, edit the b0xx.ahk file and run it directly. 
