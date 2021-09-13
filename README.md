This is an edit I made of something used to emulate a controller on a keyboard for Melee. It's based on the layout used for the expensive B0XX controller some people use in melee, which has all digital buttons on a flat surface instead of any analog sticks or anything like that. I'm not overly sure how all of this works, because I just took code from some guy (named TuberLuber on Discord/Reddit who took code from some guy (named tlandegger on Github)) that I found through the B0XX discord and changed the numbers to work with Rivals. This could also work in other games (Nickelodeon All Star Brawl???) but it's likely that the analog coordinates and relevant analog magnitudes will be different. If you want to set it up, you can just scroll down to the installation section instead of reading all this stuff. 

THIS WON'T WORK IMMEDIATELY, DO INSTALLATION STUFF AND EVEN AFTER THAT MY LAYOUT HAS ATTACK SET TO U BECAUSE I BOUND MY ALT TO U IN RAZER SYNAPSE AND YOU PROBABLY WILL HAVE TO USE A DIFFERENT BUTTON BECAUSE ALT DOESNT WORK (UNLESS MAYBE YOU DO WEIRD AHK STUFF IDK ABOUT)

SECTION 1: FUNCTIONALITY

It has modifier buttons, which means you can emulate analog control with only 4 directional buttons.
 
Holding Mod X or Mod Y is kinda like holding shift in reverse. They will make up, down, left and right input do an analog stick input of 70%, instead of 100%. In Melee, they'd have different amounts for these directions, but analog stick magnitude is much less important in Rivals of Aether. Holding either of these will result in walking, pivoting, or holding down without fastfalling. This won't effect wavedashes or recoveries, since airdodges and recoveries are only based on the angle of the analog stick, not how far you move it. The modifiers only differentiate themselves from each other when inputting a diagonal.

Note before getting into diagonals: Zetterburn has 24 UpB angles (I did the pixel measurements and stuff, so unless I got incredibly unlucky and hit 60 degrees 3 times in a row exactly, that's true). There's the classic 8 you can get using normal keyboard controls, then 2 in between 0 and 45 degrees, 2 in between 45 and 90, etc. These angles are all equally spaced by 15 degrees, meaning the steepest non-vertical angle is 75 degrees, and the shallowest non-horizontal angle is 15 degrees.

Holding Mod X and inputting a diagonal will make a 20 degree angle from the x axis. See what this looks like in the Mod X image. This is useful for a wavedash/waveland/airdodge between 0 and 45 degrees and the 15 degree Zetter UpB angle. You can think of Mod X as bringing the diagonals closer to the x axis.

Holding Mod Y and inputting a diagonal will make a 70 degree angle from the x axis. See what this looks like in the Mod Y image. This is useful for a wavedash/waveland/airdodge between 45 and 90 and the 75 degree Zetter UpB angle. You can think of Mod Y as bringing the diagonals closer to the y axis. You'd think this would be useful for doing U and D attacks while running and turning around or something, but you can actually do all of that with the normal 45 degree diagonals. However, if you want to do any of this with a slight tilt/pivot/walk, you will need to use Mod Y instead of Mod X.

There are a couple of Zetter UpB angles missing with just these 2 modifiers, the 30 degree angle and the 60 degree angle. To achieve the 30 degree angle, hold any of the c stick/right analog stick buttons while holding Mod X. For the 60 degree angle, hold any of the c stick/right analog stick buttons while holding Mod Y. I think you could also do this with airdodges/wavedashes/wavelands, but that isn't very useful, since you already have 16 nearly evenly spaced airdodge directions, the extra thought/muscle memory training for that is a bit much, and it will probably cause you to buffer an attack most of the time. 


SECTION 2: LAYOUT PHILOSOPHY/RECOMMENDED USE

You may have seen the layout and been very confused. That's because the original goal of the B0XX was to be as good as possible for whoever mastered it. For example, Up is on the right pinky, completely separate from the other directions, and very different from how most games with keyboard controls are. This is probably better than using the normal arrow key layout both ergonomically and speed wise (moving the middle finger between the up and down keys is slower than if you already have a finger on the key and causes a bit more strain than with this layout) but that's not really important and you can change the layout if you want.

Keeping the modifier keys on a thumb separate from other buttons means you can hold those down without losing any control. Putting them on the pinkies causes more strain but most people will be fine with that, just make sure the modifiers don't impede using any other buttons.

You definitely want jump to have it's own finger, because a lot of actions require jumping and pressing a button immediately afterward (aerials, wavedashes, aerial specials, aerial strong attacks, etc.). I recommend the middle finger, because it is stronger than the ring and pinky which means less strain, the pointer finger is more flexible and should have a variety of controls assigned to it, and the rolling motion of pressing with your middle finger and then pressing with your index finger for a wavedash or a jump special feels good.

The ring finger position would normally be set to grab/L cancel in Melee, which RoA doesn't have. The reason I have it empty instead of setting it to strong, which Melee doesn't have, is because Nickelodeon All Star Brawl will have grabs and strongs, and I don't want to relearn any controls when that comes out. If you intend to use this mainly for Rivals, then it makes a lot of sense to set strong to that key.

The index finger has 3 buttons, dodge, special and strong. The B0XX has the positions of special and dodge/shield swapped, but I personally think wavedashing is a bit more relevant than specials in terms of how fast you'd want to input it and comfort, so I put dodge where my pointer finger rests. 

The C Stick situation sucks. It feels very awkward to use, but I can't think of a better solution, and the normal attack button isn't bad being where my thumb rests. I haven't had much time to use the keyboard emulation, so hopefully it will get better when I get used to it. I do think that because of the C Stick, this "controller" makes movement and tech easier while making attacking a bit more difficult.

The shorthop thing is set because why not.

Keep in mind that I designed this layout based on my situation, having a 60% keyboard and pretty large hands. I'm also not very opposed to learning a very strange and unintuitive layout. If you have a full size keyboard, then putting your right hand on the numpad is a good idea, and you can always bring stuff in my layout down a row. If you want to see other layouts used for the b0xx, join that discord through the box website and ctrl+f    has:image keyB0XX   in all channels

I recommend that you wavedash with the pointer finger dodge instead of the left pinky, because the left pinky is a lot weaker

For a waveshine with Zetterburn, you might want to use the pinky dodge because your pointer finger was just used for special. However, for most people, special and dodge are close enough that you can still easily use the pointer dodge for the wavedash.

You might want to tech and parry with the left pinky instead of the right pointer, but it doesn't really matter in rivals. The reason there is a dodge on the left pinky is for wavedashing out of shield in other platform fighters.


SECTION 3: INSTALLATION AND USE

0. You have to have Windows and probably should have a keyboard with high n-key rollover. N-key rollover means how many keys you can press at once before the inputs stop counting. Mechanical keyboards and gaming keyboards almost definitely have sufficient N-key rollover, while laptop and other keyboards likely won't have this feature. You can test it at https://keyboardchecker.com/ The layout seen in the craptop image will probably be better for you if you have low N-key rollover, but you probably should just use a normal controller.
  
1. Download vJoy from  https://sourceforge.net/projects/vjoystick/?source=typ_redirect
2. Install it, search in the start menu "Configure vJoy", then set the number of buttons to 12
3. Install Autohotkey from  https://autohotkey.com/
4. Install AHK-CvJOyInterface from  https://github.com/evilC/AHK-CvJoyInterface
5. Place the CvJoyInterface.ahk file in Autohotkey's Lib folder, probably found in C:\Program Files\
AutoHotkey\Lib    You may have to create the Lib folder
6. Make sure you've extracted all the stuff from this zip folder, and then you can use it by running b0xx.exe

When you run the exe, go to the side tray thing (bottom right up arrow of windows taskbar where you can do volume and wifi stuff) and right click on the big H autohotkey icon. There, you can pause it, edit the controls, or close it. You can also press Ctrl+Alt+S to pause it and use your keyboard normally again without having to close it in the side tray.

You may want to edit the steam controller configuration for the virtual controller. Make all the deadzones zero and stuff

In game, edit the controller profiles. Set all the buttons to what you want, and then go to the control stick sensitivity thing. Make the red thing 5% to prevent accidental dashes when hitting diagonal coordinates or using modifiers.

Make sure you're always launching the .exe, as launching the .ahk will be weird, buggy and slow.


SECTION 4: EDITING LAYOUT

Editing the controls is pretty easy. There's a checkbox that when ticked will stop any keys used as controls from performing their default function. I recommend that you put this on all the controls, otherwise Rivals may think a keyboard player is trying to play too. When you want to actually use your keyboard, you also don't have to right click the thing and pause/exit it, you can just input Ctrl+Alt+S to pause it. You may want to uncheck the boxes when changing your controls, because if you keep them checked, then you can't set an input to a key that is already in use, which gets annoying. Sadly, you can't set keys to be Ctrl, Shift or Alt. For my layout, I set Right Alt to be U in Razer Synapse. If you don't have some keybind editor like that, you probably won't be able to use those buttons, but Autohotkey might have a solution I don't know about.
IMPORTANT: DON'T UNBIND ANY OF THE KEYS, EVEN DEBUG, OR YOU WON'T BE ABLE TO START THE .EXE. IF YOU END UP UNBINDING A KEY, EDIT THE hotkeys.ini FILE TO MAKE SURE EVERY NUMBER IS SET TO SOMETHING


SECTION 5: EDITING SCRIPT

If you want to edit the analog coordinates or something, backup all the files from my zip folder in another folder, delete the exe, then edit the .ahk script with notepad or something. Change what you want, save the file, and then compile the script. You do this by right clicking the .ahk, hitting Complie Script (GUI), and then hitting convert without changing any of the settings. Then you have a new .exe.

If you want to test the controller, or if it isn't working, go to https://gamepad-tester.com   If one of the axises is returning 222202020200202 or something like that, then you're coordinates are probably too high. Keep in mind that coordinates of (1,1) aren't possible on an analog stick because it's a circle and stuff. The 45 degree diagonal edge of the circle is almost (0.7, 0.7), so just use that for diagonals.

To come up with coordinates, I used desmos graphing calculator and desmos scientific calculator (google them). The graph formula for a circle is x squared + y squared = radius of the circle squared. In the scientific calculator (set it to degrees instead of radians), do tan(ANGLE in degrees), copy that number, and do  y = THATNUMBER * x to put that line on the graph. Then you can click on the intersection points between the circles and the angle lines to find coordinates to input into the thing.

If you are customizing this stuff, I recommend looking at the resources on the b0xx website, which explains how the b0xx was designed and why certain things were chosen. The stuff there is kinda long though ngl. The most useful resource is probably the Melee Manual. Also I'm pretty sure the Rival of Aether mode on the b0xx sucks

If you want to use it for Melee, find the B0XX discord on the B0XX website and do !keyboard in the bot commands channel and go through that stuff. One of the main things I changed was around line 460, where i changed the values of mx and my from 10271 to 16000. Without this change, all analog inputs were about 5/8 of what they should be magnitude wise


SECTION 6: LAST REMARKS

I don't know if I'm doing any copyright stuff right, but I downloaded most of these files from the GitHub link doing !keyboard in the b0xx discord and then edited the .ahk and my layout. Then I added a couple files like this one to make other people able to use it.

I might make a change that turns the mod X and Y angles into perfectly spaced pixel measured wavedash angles, since the angle spacing doesn't translate to wavedash spacing, but that's a bit of a pain.



