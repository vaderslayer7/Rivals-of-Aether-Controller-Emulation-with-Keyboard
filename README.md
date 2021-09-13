# RoA Controller Emulation with Keyboard
By running the .exe file, you can get your keyboard to emulate a controller. This means you can emulate analog inputs, allowing for more wavedash angles and more angles to Zetterburn's recovery than the 8 angles you can usually get with a keyboard. 

This repository is based off of one used to emulate the Melee B0XX controller, just tuned for Rivals of Aether. It can perform all 24 angles of Zetterburn's UpB and gives you 4 extra wavedash angles, each between the normal wavedash angles you can get on keyboard.

# Requirements
Windows
Keyboard with high N-Key Rollover
- N-Key Rollover is how many keys you can press at once, which isn't always a set number of keys and is often based on circuits and weird stuff like that
- Gaming keyboards and mechanical keyboards almost definitely have high or infinite N-Key Rollover
- Laptop keyboards and normal keyboards probably don't
- Check N-Key Rollover at https://keyboardchecker.com/
- The Craptop Layout in READMORE is supposedly better for how most low N-Key Rollover keyboards work, but it still isn't great, and you should probably just use a controller

# Setup
1. Download vJoy from https://sourceforge.net/projects/vjoystick/?source=typ_redirect. Install it.
2. Search in the start menu "Configure vJoy", then set the number of buttons to 12
3. Install Autohotkey from https://autohotkey.com/
4. Install AHK-CvJoyInterface from https://github.com/evilC/AHK-CvJoyInterface.
5. Place the CvJoyInterface.ahk file in Autohotkey's Lib folder, probably found in C:\Program Files\AutoHotky\Lib. You may have to create the Lib folder
6. Run B0XX.exe
7. To suspend the script, edit the controls, or exit it, find it in the program tray (arrow near time/date on windows task bar) and right click on it
8. In Rival of Aether, create a profile for your keyboard controller, and set all the keys to what you want. In the control stick sensitivity section, make sure the red arrow option is set to 5%, otherwise you might run into problems like diagonals causing dashes. Also make the white horizontal and vertical left stick options 80%.
9. Read the manual in the READMORE folder to find out how to use the controller!
10. I don't think the default layout is very good, but it should work "out of the box." If you want to use my layout, look at and read the relevant files in the READMORE folder. Also, feel free to make your own layout! Mine is very specific to my keyboard and what I'm looking for, and the default layout is based on the Melee B0XX controller instead of intuitiveness.
11. If you have any problems, you can dm me on discord at vaderslayer7 #9565, but try to Google stuff first. If there's a problem with these directions that you solve, then dm me about it with the solution (don't use any github features, I have no idea how they work)

## Changing Layout
To rebind any keys, go to edit controls from the icon on the system tray. Click on any text box to rebind a key. The Prevent Default Behavior checkbox stops the keys in use from doing their regular inputs, which stops Rivals of Aether from thinking there is a controller player (the emulated controller) and a keyboard player, but also stops you from using any of those buttons normally. (You can suspend the script by right clicking on it or by pressing Ctrl+Alt+S, allowing you to easily switch between regular keyboard use and controller emulation.) In the control editor, keep in mind that you can't change something to a key that is already in use, so you might need to do some acrobatics with that.

The specific button you bind a key to doesn't really matter, since you'll probably set up a profile in Rivals of Aether anyway. However, don't try to put anything on Light Shield, Mid Shield, or Debug, since they won't work in Rivals. Also, 

DON'T LEAVE ANY BUTTON UNBOUND. IT WILL STOP YOU FROM STARTING THE PROGRAM AGAIN. I'VE SET LIGHT SHIELD, MID SHIELD AND DEBUG TO F13-15 TO BE OUT OF THE WAY BECAUSE YOU CAN'T USE THEM IN RIVALS, AND SETTING THEM TO NOTHING CAUSES THE PROGRAM NOT TO WORK. TO REBIND ANY BUTTONS YOU SET TO UNBOUND, GO INTO HOTKEYS.INI WITH NOTEPAD AND MAKE SURE ALL THE NUMBERS HAVE A VALID KEY.

### Modifier Keys

If you want to use modifier keys (Ctrl, Alt, Shift, Windows Key, not FN because AHK can't recognize that) in your layout, they won't work by default. You can either rebind the modifier in a program like Razer Synapse or Logitech G Hub if you have a compatible keyboard, but otherwise, you might have to make your own script.

I've included a .exe called AltDisable, which makes Right Alt bind to the number 6, allowing you to use alt while that script is active. If you want to use another modifier, check the READMORE folder.
