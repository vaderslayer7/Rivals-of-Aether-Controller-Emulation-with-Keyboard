#SingleInstance force
#NoEnv
#include <CvJoyInterface>
SetBatchLines, -1

hotkeyLabels := Object()
hotkeyLabels.Insert("Analog Up")
hotkeyLabels.Insert("Analog Down")
hotkeyLabels.Insert("Analog Left")
hotkeyLabels.Insert("Analog Right")
hotkeyLabels.Insert("ModX")
hotkeyLabels.Insert("ModY")
hotkeyLabels.Insert("A")
hotkeyLabels.Insert("B")
hotkeyLabels.Insert("L")
hotkeyLabels.Insert("R")
hotkeyLabels.Insert("X")
hotkeyLabels.Insert("Y")
hotkeyLabels.Insert("Z")
hotkeyLabels.Insert("C-stick Up")
hotkeyLabels.Insert("C-stick Down")
hotkeyLabels.Insert("C-stick Left")
hotkeyLabels.Insert("C-stick Right")
hotkeyLabels.Insert("Start")
hotkeyLabels.Insert("D-pad Up")
hotkeyLabels.Insert("D-pad Down")
hotkeyLabels.Insert("D-pad Left")
hotkeyLabels.Insert("D-pad Right")

Menu, Tray, Click, 1
Menu, Tray, Add, Edit Controls, ShowGui
Menu, Tray, Default, Edit Controls

#ctrls = 22  ;Total number of Key's we will be binding (excluding UP's)?

for index, element in hotkeyLabels{
 Gui, Add, Text, xm vLB%index%, %element% Hotkey:
 IniRead, savedHK%index%, Hotkeys.ini, Hotkeys, %index%, %A_Space%
 If savedHK%index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%index%, Label%index%                 ;Activate saved hotkeys if found.
  Hotkey,% savedHK%index% . " UP", Label%index%_UP                 ;Activate saved hotkeys if found.
  ;TrayTip, Smashbox, Label%index%_UP, 3, 0
  ;TrayTip, Smashbox, % savedHK%A_Index%, 3, 0
  ;TrayTip, Smashbox, % savedHK%index% . " UP", 3, 0
 checked := false
 if(!InStr(savedHK%index%, "~", false)){
  checked := true
 }
 StringReplace, noMods, savedHK%index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%index% gGuiLabel, %noMods%        ;Add hotkey controls and show saved hotkeys.
 if(!checked)
  Gui, Add, CheckBox, x+5 vCB%index% gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
 else
  Gui, Add, CheckBox, x+5 vCB%index% Checked gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
}                                                               ;Check the box if Win modifier is used.


;----------Start Hotkey Handling-----------

; Create an object from vJoy Interface Class.
vJoyInterface := new CvJoyInterface()

; Was vJoy installed and the DLL Loaded?
if (!vJoyInterface.vJoyEnabled()) {
  ; Show log of what happened
  Msgbox % vJoyInterface.LoadLibraryLog
  ExitApp
}

myStick := vJoyInterface.Devices[1]

; Alert User that script has started
TrayTip, Smashbox, Script Started, 3, 0

; state variables
buttonUp := false
buttonDown := false
buttonLeft := false
buttonRight := false

buttonB := false
buttonZ := false

buttonL := false
buttonR := false

buttonModX := false
buttonModY := false

buttonCUp := false
buttonCDown := false
buttonCLeft := false
buttonCRight := false

mostRecentVertical := ""
mostRecentHorizontal := ""

; b0xx constants
coordsOrigin := [0, 0]
coordsVertical := [0, 1]
coordsVerticalModX := [0, 0.2875]
coordsVerticalModY := [0, 0.7375]
coordsHorizontal := [1, 0]
coordsHorizontalModX := [0.6625, 0]
coordsHorizontalModY := [0.3375, 0]
coordsQuadrant := [0.7, 0.7]
coordsQuadrantModX := [0.7375, 0.2875]
coordsQuadrantModY := [0.2875, 0.7375]

coordsRButtonVertical := [0, 0.5375] ; TODO - find out how/if ModX and ModY affect cardinal directions
coordsRButtonHorizontal := [0.6375, 0]
coordsRButtonQuadrant := [0.5375, 0.5375]
coordsRButtonQuadrant12ModX := coordsQuadrantModX ; TODO - find actual values for R+modifier upward angles
coordsRButtonQuadrant12ModY := coordsQuadrantModY
coordsRButtonQuadrant34ModX := [0.6375, 0.375]
coordsRButtonQuadrant34ModY := [0.5, 0.85]

coordsLZButtonVertical := coordsVertical
coordsLZButtonHorizontal := coordsHorizontal
coordsLZButtonQuadrant12 := coordsRButtonQuadrant
coordsLZButtonQuadrant12ModX := coordsQuadrantModX
coordsLZButtonQuadrant12ModY := coordsQuadrantModY
coordsLZButtonQuadrant34 := [0.7125, 0.6875]
coordsLZButtonQuadrant34ModX := coordsRButtonQuadrant34ModX
coordsLZButtonQuadrant34ModY := coordsRButtonQuadrant34ModY

; TODO - add firefox angles
; TODO - add SDI nerf
; TODO - add pivot utilt nerf

displayedDebug := false ; FIXME

; Updates the position on the analog stick based on the current held buttons
updateStick() {
  global

  if (buttonUp and (mostRecentVertical == "U")) {
    vert := "U"
  } else if (buttonDown and (mostRecentVertical == "D")) {
    vert := "D"
  } else {
    vert := ""
  }

  if (buttonLeft and (mostRecentHorizontal == "L")) {
    horiz := "L"
  } else if (buttonRight and (mostRecentHorizontal == "R")) {
    horiz := "R"
  } else {
    horiz := ""
  }

  if (neither(buttonModX, buttonModY) or (buttonModX and buttonModY) or (buttonLeft and buttonRight)) {
    modif := ""
  } else if (buttonModX) {
    modif := "X"
  } else {
    modif := "Y"
  }

  if (buttonR) {
    coords := getCoordsWithR(vert, horiz, modif)
  } else if (buttonL or buttonZ) {
    coords := getCoordsWithLZ(vert, horiz, modif)
  } else {
    coords := getCoordsWithNoShield(vert, horiz, modif)
  }

  reflectedCoords := reflectCoords(coords, vert, horiz)

  ; FIXME
  debugString := Format(debugFormatString
    , reflectedCoords
    , vert
    , horiz
    , modif
    , buttonUp, buttonDown, buttonLeft, buttonRight, buttonModX, buttonModY
    , buttonL, buttonR, buttonZ, buttonB)
  if (displayedDebug == false) {
    ;displayedDebug := true
    ;Msgbox % debugString
  }

  setStick(reflectedCoords)
}

reflectCoords(coords, vert, horiz) {
  x := coords[1]
  y := coords[2]
  if (vert == "U") {
    y := -y
  }
  if (horiz == "L") {
    x := -x
  }
  return [x, y]
}

getCoordsWithR(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    switch modif {
      case "X":
        if (vert == "U") {
          return coordsRButtonQuadrant12ModX
        } else {
          return coordsRButtonQuadrant34ModX
        }
      case "Y":
        if (vert == "U") {
          return coordsRButtonQuadrant12ModY
        } else {
          return coordsRButtonQuadrant34ModY
        }
      default:
        return coordsRButtonQuadrant
    }
  } else if (vert) {
    return coordsRButtonVertical
  } else {
    return coordsRButtonHorizontal
  }
}

getCoordsWithLZ(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    switch modif {
      case "X":
        if (vert == "U") {
          return coordsLZButtonQuadrant12ModX
        } else {
          return coordsLZButtonQuadrant34ModX
        }
      case "Y":
        if (vert == "U") {
          return coordsLZButtonQuadrant12ModY
        } else {
          return coordsLZButtonQuadrant34ModY
        }
      default:
        if (vert == "U") {
          return coordsLZButtonQuadrant12
        } else {
          return coordsLZButtonQuadrant34
        }
    }
  } else if (vert) {
    return coordsLZButtonVertical
  } else {
    return coordsLZButtonHorizontal
  }
}

getCoordsWithNoShield(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    switch modif {
      case "X":
        return coordsQuadrantModX
      case "Y":
        return coordsQuadrantModY
      default:
        return coordsQuadrant
    }
  } else if (vert) {
    switch modif {
      case "X":
        return coordsVerticalModX
      case "Y":
        return coordsVerticalModY
      default:
        return coordsVertical
    }
  } else {
    switch modif {
      case "X":
        return coordsHorizontalModX
      case "Y":
        if (buttonB) { ; turnaround side-b nerf
          return coordsHorizontal
        } else {
          return coordsHorizontalModY
        }
      default:
        return coordsHorizontal
    }
  }
}

setStick(coords) {
  global
  myStick.SetAxisByIndex(convertToVJoy(coords[1]), 1)
  myStick.SetAxisByIndex(convertToVJoy(coords[2]), 2)
  if (displayedDebug == false) {
    ;displayedDebug := true
    ;Msgbox % Format("Set stick to [{1}, {2}] ([{3}, {4}])", coords[1], coords[2], convertToVJoy(coords[1]), -convertToVJoy(coords[2]))
  }
}

convertToVJoy(coord) {
  global
  if (not displayedDebug) {
    ;displayedDebug := true
    ;Msgbox % Format("Converting melee coordingate {1} to vJoy. Percent: {2}, vJoy: {3}", coord, (50 * (coord + 1)), vJoyInterface.PercentTovJoy(50 * (coord + 1)))
  }
  return vJoyInterface.PercentTovJoy(50 * (coord + 1))
}

neither(a, b) {
  return (not a) and (not b)
}

debugFormatString = 
(
  melee coords: {1}
  vert: {2}
  horiz: {3}
  modif: {4}
  direction buttons: (u/d/l/r/mx/my): {5}/{6}/{7}/{8}/{9}/{10}
  action buttons (L/R/Z/B): {11}/{12}/{13}/{14}
)

validateHK(GuiControl) {
 global lastHK
 Gui, Submit, NoHide
 lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
 num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
  StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
  ;If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
   ;HK%num% := "#" HK%num%
  If (!CB%num% && !RegExMatch(HK%num%,"[#!\^\+]"))       ;  If the new hotkey has no modifiers, add the (~) modifier.
   HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
  checkDuplicateHK(num)
 }
 If (savedHK%num% || HK%num%)               ;Unless both are empty,
  setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}

checkDuplicateHK(num) {
 global #ctrls
 Loop,% #ctrls
  If (HK%num% = savedHK%A_Index%) {
   dup := A_Index
   TrayTip, Smashbox, Hotkey Already Taken, 3, 0
   Loop,6 {
    GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
    Sleep,200
   }
   GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
   break
  }
}

setHK(num,INI,GUI) {
 If INI{                          ;If previous hotkey exists,
  Hotkey, %INI%, Label%num%, Off  ;  disable it.
  Hotkey, %INI% UP, Label%num%_UP, Off  ;  disable it.
}
 If GUI{                           ;If new hotkey exists,
  Hotkey, %GUI%, Label%num%, On   ;  enable it.
  Hotkey, %GUI% UP, Label%num%_UP, On   ;  enable it.
}
 IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 ;TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
 *AppsKey::                       ;Add support for these special keys,
 *BackSpace::                     ;  which the hotkey control does not normally allow.
 *Delete::
 *Enter::
 *Escape::
 *Pause::
 *PrintScreen::
 *Space::
 *Tab::
  modifier := ""
  If GetKeyState("Shift","P")
   modifier .= "+"
  If GetKeyState("Ctrl","P")
   modifier .= "^"
  If GetKeyState("Alt","P")
   modifier .= "!"
  Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
  If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
   GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
  Else                                                     ;Otherwise,
   GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
  validateHK(ctrl)
 return
#If

HotkeyCtrlHasFocus() {
 GuiControlGet, ctrl, Focus       ;ClassNN
 If InStr(ctrl,"hotkey") {
  GuiControlGet, ctrl, FocusV     ;Associated variable
  Return, ctrl
 }
}


;----------------------------Labels

;Show GUI from tray Icon
ShowGui:
    Gui, show,, Dynamic Hotkeys
    GuiControl, Focus, LB1 ; this puts the windows "focus" on the checkbox, that way it isn't immediately waiting for input on the 1st input box
return

GuiLabel:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
  GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
 Else
  validateHK(A_GuiControl)
return

;-------macros

Pause::Suspend
^!r:: Reload
SetKeyDelay, 0
#MaxHotkeysPerInterval 200

^!s::
  Suspend
    If A_IsSuspended
        TrayTip, Smashbox, Hotkeys Disabled, 3, 0
    Else
        TrayTip, Smashbox, Hotkeys Enabled, 3, 0
  Return


; Analog Up
Label1:
  buttonUp := true
  mostRecentVertical := "U"
  updateStick()
  return

Label1_UP:
  buttonUp := false
  updateStick()
  return

; Analog Down
Label2:
  buttonDown := true
  mostRecentVertical := "D"
  updateStick()
  return

Label2_UP:
  buttonDown := false
  updateStick()
  return

; Analog Left
Label3:
  buttonLeft := true
  mostRecentHorizontal := "L"
  updateStick()
  return

Label3_UP:
  buttonLeft := false
  updateStick()
  return

; Analog Right
Label4:
  buttonRight := true
  mostRecentHorizontal := "R"
  updateStick()
  return

Label4_UP:
  buttonRight := false
  updateStick()
  return

; ModX
Label5:
  buttonModX := true
  updateStick()
  return

Label5_UP:
  buttonModX := false
  updateStick()
  return

; ModY
Label6:
  buttonModY := true
  updateStick()
  return

Label6_UP:
  buttonModY := false
  updateStick()
  return

; A
Label7:
  myStick.SetBtn(1,1)
  return

Label7_UP:
  myStick.SetBtn(0,1)
  return

; B
Label8:
  buttonB := true
  myStick.SetBtn(1, 2)
  updateStick()
  return

Label8_UP:
  buttonB := false
  myStick.SetBtn(0, 2)
  updateStick()
  return

; L
Label9:
  buttonL := true
  myStick.SetBtn(1, 3)
  updateStick()
  return

Label9_UP:
  buttonL := false
  myStick.SetBtn(0, 3)
  updateStick()
  return

; R
Label10:
  buttonR := true
  myStick.SetBtn(1, 4)
  updateStick()
  return

Label10_UP:
  buttonR := false
  myStick.SetBtn(0, 4)
  updateStick()
  return

; X
Label11:
  myStick.SetBtn(1, 5)
  return

Label11_UP:
  myStick.SetBtn(0, 5)
  return

; Y
Label12:
  myStick.SetBtn(1, 6)
  return

Label12_UP:
  myStick.SetBtn(0, 6)
  return

; Z
Label13:
  buttonZ := true
  myStick.SetBtn(1, 7)
  updateStick()
  return

Label13_UP:
  buttonZ := false
  myStick.SetBtn(0, 7)
  updateStick()
  return

; C Up
Label14:
  clearC()
  buttonCUp := true
  if (buttonModX and buttonModY) {
      ; Pressing ModX and ModY simultaneously changes C buttons to D pad
      myStick.SetBtn(1, 13)
  } else {
      myStick.SetBtn(1, 8)
  }
  updateStick()
  return

Label14_UP:
  buttonCUp := false
  myStick.SetBtn(0, 8)
  myStick.SetBtn(0, 13)
  updateStick()
  return

; C Down
Label15:
  clearC()
  buttonCDown := true
  if (buttonModX and buttonModY) {
      ; Pressing ModX and ModY simultaneously changes C buttons to D pad
      myStick.SetBtn(1, 14)
  } else {
      myStick.SetBtn(1, 9)
  }
  updateStick()
  return

Label15_UP:
  buttonCDown := false
  myStick.SetBtn(0, 9)
  myStick.SetBtn(0, 14)
  updateStick()
  return

; C Left
Label16:
  clearC()
  buttonCLeft := true
  if (buttonModX and buttonModY) {
      ; Pressing ModX and ModY simultaneously changes C buttons to D pad
      myStick.SetBtn(1, 15)
  } else {
      myStick.SetBtn(1, 10)
  }
  updateStick()
  return

Label16_UP:
  buttonCLeft := false
  myStick.SetBtn(0, 10)
  myStick.SetBtn(0, 15)
  updateStick()
  return

; C Right
Label17:
  clearC()
  buttonCRight := true
  if (buttonModX and buttonModY) {
      ; Pressing ModX and ModY simultaneously changes C buttons to D pad
      myStick.SetBtn(1, 16)
  } else {
      myStick.SetBtn(1, 11)
  }
  updateStick()
  return

Label17_UP:
  buttonCRight := false
  myStick.SetBtn(0, 11)
  myStick.SetBtn(0, 16)
  updateStick()
  return

; Start
Label18:
  myStick.SetBtn(1, 12)
  return

Label18_UP:
  myStick.SetBtn(0, 12)
  return

; D Up
Label19:
  myStick.SetBtn(1, 13)
  return

Label19_UP:
  myStick.SetBtn(0, 13)
  return

; D Down
Label20:
  myStick.SetBtn(1, 14)
  return

Label20_UP:
  myStick.SetBtn(0, 14)
  return

; D Left
Label21:
  myStick.SetBtn(1, 15)
  return

Label21_UP:
  myStick.SetBtn(0, 15)
  return

; D Right
Label22:
  myStick.SetBtn(1, 16)
  return

Label22_UP:
  myStick.SetBtn(0, 16)
  return


clearC() {
  buttonCUp := false
  buttonCDown := false
  buttonCLeft := false
  buttonCRight := false
}

/*
TODO:
make suspend, refresh, and quit all be user-assignable hotkeys
make it so there is a way users can choose to disable certain keys (that they're not using in macros, but don't want to be in the way like DF said)
make a master button or checkbox that will check all / uncheck all of the checkboxes
*/
