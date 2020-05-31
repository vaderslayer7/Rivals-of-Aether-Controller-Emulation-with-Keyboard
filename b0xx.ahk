#SingleInstance force
#NoEnv
#include <CvJoyInterface>
SetBatchLines, -1

hotkeys := [ "Analog Up"
           , "Analog Down"
           , "Analog Left"
           , "Analog Right"
           , "ModX"
           , "ModY"
           , "A"
           , "B"
           , "L"
           , "R"
           , "X"
           , "Y"
           , "Z"
           , "C-stick Up"
           , "C-stick Down"
           , "C-stick Left"
           , "C-stick Right"
           , "Start"
           , "D-pad Up"
           , "D-pad Down"
           , "D-pad Left"
           , "D-pad Right"
           , "Debug"]

Menu, Tray, Click, 1
Menu, Tray, Add, Edit Controls, ShowGui
Menu, Tray, Default, Edit Controls

for index, element in hotkeys{
 Gui, Add, Text, xm vLB%index%, %element% Hotkey:
 IniRead, savedHK%index%, hotkeys.ini, Hotkeys, %index%, %A_Space%
 If savedHK%index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%index%, Label%index%                 ;Activate saved hotkeys if found.
  Hotkey,% savedHK%index% . " UP", Label%index%_UP                 ;Activate saved hotkeys if found.
  ;TrayTip, B0XX, Label%index%_UP, 3, 0
  ;TrayTip, B0XX, % savedHK%A_Index%, 3, 0
  ;TrayTip, B0XX, % savedHK%index% . " UP", 3, 0
 checked := false
 if(!InStr(savedHK%index%, "~", false)){
  checked := true
 }
 StringReplace, noMods, savedHK%index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 w50 vHK%index% gGuiLabel, %noMods%        ;Add hotkey controls and show saved hotkeys.
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
TrayTip, B0XX, Script Started, 3, 0

; state variables
buttonUp := false
buttonDown := false
buttonLeft := false
buttonRight := false

buttonA := false
buttonB := false
buttonL := false
buttonR := false
buttonX := false
buttonY := false
buttonZ := false

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

coordsRShieldVertical := [0, 0.5375] ; TODO - find out how/if ModX and ModY affect cardinal directions
coordsRShieldHorizontal := [0.6375, 0]
coordsRShieldQuadrant := [0.5375, 0.5375]
coordsRShieldQuadrant12ModX := coordsRShieldQuadrant ; TODO - verify that modiefiers have no affect on upward quadrant angles with R
coordsRShieldQuadrant12ModY := coordsRShieldQuadrant
coordsRShieldQuadrant34ModX := [0.6375, 0.375]
coordsRShieldQuadrant34ModY := [0.5, 0.85]

coordsLZShieldVertical := coordsVertical
coordsLZShieldHorizontal := coordsHorizontal
coordsLZShieldQuadrant12 := coordsQuadrant
coordsLZShieldQuadrant12ModX := coordsQuadrantModX
coordsLZShieldQuadrant12ModY := coordsQuadrantModY
coordsLZShieldQuadrant34 := [0.7125, 0.6875]
coordsLZShieldQuadrant34ModX := coordsRShieldQuadrant34ModX
coordsLZShieldQuadrant34ModY := coordsRShieldQuadrant34ModY

coordsFirefoxModXCDown := [0.6125, 0.3000]  ; ~26 deg
coordsFirefoxModXCLeft := [0.6500, 0.3875]  ; ~31 deg
coordsFirefoxModXCUp := [0.6125, 0.4375]    ; ~36 deg
coordsFirefoxModXCRight := [0.6375, 0.5375] ; ~40 deg
coordsFirefoxModYCRight := [0.5875, 0.7125] ; ~50 deg
coordsFirefoxModYCUp := [0.5625, 0.7875]    ; ~54 deg
coordsFirefoxModYCLeft := [0.4250, 0.7125]  ; ~59 deg
coordsFirefoxModYCDown := [0.3500, 0.7125]  ; ~64 deg

coordsExtendedFirefoxModX := [0.9250, 0.3625]       ; ~21 deg
coordsExtendedFirefoxModXCDown := [0.8875, 0.4375]  ; ~26 deg
coordsExtendedFirefoxModXCLeft := [0.8500, 0.5125]  ; ~31 deg
coordsExtendedFirefoxModXCUp := [0.7625, 0.5375]    ; ~36 deg
coordsExtendedFirefoxModXCRight := [0.6375, 0.5375] ; ~40 deg
coordsExtendedFirefoxModYCRight := [0.5875, 0.7125] ; ~50 deg
coordsExtendedFirefoxModYCUp := [0.5750, 0.8000]    ; ~54 deg
coordsExtendedFirefoxModYCLeft := [0.5125, 0.8500]  ; ~59 deg
coordsExtendedFirefoxModYCDown := [0.4375, 0.8875]  ; ~64 deg
coordsExtendedFirefoxModY := [0.3625, 0.9250]       ; ~69 deg

; TODO - add firefox angles
; TODO - add SDI nerf
; TODO - add pivot utilt nerf

; Updates the position on the analog stick based on the current held buttons
updateAnalogStick() {
  setAnalogStick(getAnalogCoords())
}

updateCStick() {
  setCStick(getCStickCoords())
}

reflectCoords(coords, vert, horiz) {
  x := coords[1]
  y := coords[2]
  if (vert == "D") {
    y := -y
  }
  if (horiz == "L") {
    x := -x
  }
  return [x, y]
}

getAnalogCoords() {
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
    coords := getAnalogCoordsWithR(vert, horiz, modif)
  } else if (buttonL or buttonZ) {
    coords := getAnalogCoordsWithLZ(vert, horiz, modif)
  } else {
    coords := getAnalogCoordsWithNoShield(vert, horiz, modif)
  }

  return reflectCoords(coords, vert, horiz)
}

getAnalogCoordsWithR(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    switch modif {
      case "X":
        return vert == "U" ? coordsRShieldQuadrant12ModX : coordsRShieldQuadrant34ModX
      case "Y":
        return vert == "U" ? coordsRShieldQuadrant12ModY : coordsRShieldQuadrant34ModY
      default:
        return coordsRShieldQuadrant
    }
  } else if (vert) {
    return coordsRShieldVertical
  } else {
    return coordsRShieldHorizontal
  }
}

getAnalogCoordsWithLZ(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    if (buttonZ and modif and not buttonL) {
      ; Z + modifier + quadrant ddirection is an extended firefox angle (same direction, greater magnitude/tilt)
      return modif == "X" ? coordsExtendedFirefoxModX : coordsExtendedFirefoxModY
    } else {
      switch modif {
        case "X":
          return vert == "U" ? coordsLZShieldQuadrant12ModX : coordsLZShieldQuadrant34ModX
        case "Y":
          return vert == "U" ? coordsLZShieldQuadrant12ModY : coordsLZShieldQuadrant34ModY
        default:
          return vert == "U" ? coordsLZShieldQuadrant12 : coordsLZShieldQuadrant34
      }
    }
  } else if (vert) {
    return coordsLZShieldVertical
  } else {
    return coordsLZShieldHorizontal
  }
}

getAnalogCoordsWithNoShield(vert, horiz, modif) {
  global
  if (neither(vert, horiz)) {
    return coordsOrigin
  } else if (vert and horiz) {
    if (anyC() and (modif == "X" or modif == "Y")) {
      return getAnalogCoordsFirefox(vert, horiz, modif)
    } else {
      switch modif {
        case "X":
          return coordsQuadrantModX
        case "Y":
          return coordsQuadrantModY
        default:
          return coordsQuadrant
      }
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
        return buttonB ? coordsHorizontal : coordsHorizontalModY ; turnaround side-b nerf
      default:
        return coordsHorizontal
    }
  }
}

getAnalogCoordsFirefox(vert, horiz, modif) {
  global
  if (modif == "X") {
    if (buttonCUp) { ; code doesn't allow multiple c button variables to be true at once
      return buttonZ ? coordsExtendedFirefoxModXCUp : coordsFirefoxModXCUp
    } else if (buttonCDown) {
      return buttonZ ? coordsExtendedFirefoxModXCDown : coordsFirefoxModXCDown
    } else if (buttonCLeft) {
      return buttonZ ? coordsExtendedFirefoxModXCLeft : coordsFirefoxModXCLeft
    } else if (buttonCRight) {
      return buttonZ ? coordsExtendedFirefoxModXCRight : coordsFirefoxModXCRight
    }
  } else if (modif == "Y") {
    if (buttonCUp) { ; code doesn't allow multiple c button variables to be true at once
      return buttonZ ? coordsExtendedFirefoxModYCUp : coordsFirefoxModYCUp
    } else if (buttonCDown) {
      return buttonZ ? coordsExtendedFirefoxModYCDown : coordsFirefoxModYCDown
    } else if (buttonCLeft) {
      return buttonZ ? coordsExtendedFirefoxModYCLeft : coordsFirefoxModYCLeft
    } else if (buttonCRight) {
      return buttonZ ? coordsExtendedFirefoxModYCRight : coordsFirefoxModYCRight
    }
  }
}

setAnalogStick(coords) {
  global
  convertedCoords := convertCoords(coords)
  myStick.SetAxisByIndex(convertedCoords[1], 1)
  myStick.SetAxisByIndex(convertedCoords[2], 2)
}

getCStickCoords() {
  global

  ; Unlike analog direction buttons, this script unsets any existing C button press
  ; variables when a new C button is pressed, so only one is true at a time
  if (buttonCUp) {
    return [0, 1]
  } else if (buttonCDown) {
    return [0, -1]
  } else if (buttonCLeft) {
    if (buttonModX and buttonUp) {
      return [-0.9, 0.5]
    } else if (buttonModX and buttonDown) {
      return [-0.9, -0.5]
    } else {
      return [-1, 0]
    }
  } else if (buttonCRight) {
    if (buttonModX and buttonUp) {
      return [0.9, 0.5]
    } else if (buttonModX and buttonDown) {
      return [0.9, -0.5]
    } else {
      return [1, 0]
    }
  } else {
    return [0, 0]
  }
}

setCStick(coords) {
  global
  convertedCoords := convertCoords(coords)
  myStick.SetAxisByIndex(convertedCoords[1], 4)
  myStick.SetAxisByIndex(convertedCoords[2], 5)
}

; Converts coordinates from melee values (-1 to 1) to vJoy values (0 to 32767).
mx = 10271 ; Why this number? idk, I would have thought it should be 16384 * (80 / 128) = 10240, but this works
my = -10271
bx = 16448 ; 16384 + 64
by = 16320 ; 16384 - 64
convertCoords(coords) {
  global
  return [ mx * coords[1] + bx
         , my * coords[2] + by ]
}

anyC() {
  global
  return buttonCUp or buttonCDown or buttonCLeft or buttonCRight
}

neither(a, b) {
  return (not a) and (not b)
}

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
 global
 Loop,% hotkeys.Length()
  If (HK%num% = savedHK%A_Index%) {
   dup := A_Index
   TrayTip, B0XX, Hotkey Already Taken, 3, 0
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
 IniWrite,% GUI ? GUI:null, hotkeys.ini, Hotkeys, %num%
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
        TrayTip, B0XX, Hotkeys Disabled, 3, 0
    Else
        TrayTip, B0XX, Hotkeys Enabled, 3, 0
  Return


; Analog Up
Label1:
  buttonUp := true
  mostRecentVertical := "U"
  updateAnalogStick()
  return

Label1_UP:
  buttonUp := false
  updateAnalogStick()
  return

; Analog Down
Label2:
  buttonDown := true
  mostRecentVertical := "D"
  updateAnalogStick()
  return

Label2_UP:
  buttonDown := false
  updateAnalogStick()
  return

; Analog Left
Label3:
  buttonLeft := true
  mostRecentHorizontal := "L"
  updateAnalogStick()
  return

Label3_UP:
  buttonLeft := false
  updateAnalogStick()
  return

; Analog Right
Label4:
  buttonRight := true
  mostRecentHorizontal := "R"
  updateAnalogStick()
  return

Label4_UP:
  buttonRight := false
  updateAnalogStick()
  return

; ModX
Label5:
  buttonModX := true
  updateAnalogStick()
  return

Label5_UP:
  buttonModX := false
  updateAnalogStick()
  return

; ModY
Label6:
  buttonModY := true
  updateAnalogStick()
  return

Label6_UP:
  buttonModY := false
  updateAnalogStick()
  return

; A
Label7:
  buttonA := true
  myStick.SetBtn(1,5)
  return

Label7_UP:
  buttonA := false
  myStick.SetBtn(0,5)
  return

; B
Label8:
  buttonB := true
  myStick.SetBtn(1, 4)
  updateAnalogStick()
  return

Label8_UP:
  buttonB := false
  myStick.SetBtn(0, 4)
  updateAnalogStick()
  return

; L
Label9:
  buttonL := true
  myStick.SetBtn(1, 1)
  updateAnalogStick()
  return

Label9_UP:
  buttonL := false
  myStick.SetBtn(0, 1)
  updateAnalogStick()
  return

; R
Label10:
  buttonR := true
  myStick.SetBtn(1, 3)
  updateAnalogStick()
  return

Label10_UP:
  buttonR := false
  myStick.SetBtn(0, 3)
  updateAnalogStick()
  return

; X
Label11:
  buttonX := true
  myStick.SetBtn(1, 6)
  return

Label11_UP:
  buttonX := false
  myStick.SetBtn(0, 6)
  return

; Y
Label12:
  buttonY := true
  myStick.SetBtn(1, 2)
  return

Label12_UP:
  buttonY := false
  myStick.SetBtn(0, 2)
  return

; Z
Label13:
  buttonZ := true
  myStick.SetBtn(1, 7)
  updateAnalogStick()
  return

Label13_UP:
  buttonZ := false
  myStick.SetBtn(0, 7)
  updateAnalogStick()
  return

; C Up
Label14:
  clearC()
  if (buttonModX and buttonModY) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 9)
  } else {
    buttonCUp := true
    updateCStick()
    updateAnalogStick()
  }
  return

Label14_UP:
  buttonCUp := false
  myStick.SetBtn(0, 9)
  updateCStick()
  updateAnalogStick()
  return

; C Down
Label15:
  clearC()
  if (buttonModX and buttonModY) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 11)
  } else {
    buttonCDown := true
    updateCStick()
    updateAnalogStick()
  }
  return

Label15_UP:
  buttonCDown := false
  myStick.SetBtn(0, 11)
  updateCStick()
  updateAnalogStick()
  return

; C Left
Label16:
  clearC()
  if (buttonModX and buttonModY) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 10)
  } else {
    buttonCLeft := true
    updateCStick()
    updateAnalogStick()
  }
  return

Label16_UP:
  buttonCLeft := false
  myStick.SetBtn(0, 10)
  updateCStick()
  updateAnalogStick()
  return

; C Right
Label17:
  clearC()
  if (buttonModX and buttonModY) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 12)
  } else {
    buttonCRight := true
    updateCStick()
    updateAnalogStick()
  }
  return

Label17_UP:
  buttonCRight := false
  myStick.SetBtn(0, 12)
  updateCStick()
  updateAnalogStick()
  return

; Start
Label18:
  myStick.SetBtn(1, 8)
  return

Label18_UP:
  myStick.SetBtn(0, 8)
  return

; D Up
Label19:
  myStick.SetBtn(1, 9)
  return

Label19_UP:
  myStick.SetBtn(0, 9)
  return

; D Down
Label20:
  myStick.SetBtn(1, 11)
  return

Label20_UP:
  myStick.SetBtn(0, 11)
  return

; D Left
Label21:
  myStick.SetBtn(1, 10)
  return

Label21_UP:
  myStick.SetBtn(0, 10)
  return

; D Right
Label22:
  myStick.SetBtn(1, 12)
  return

Label22_UP:
  myStick.SetBtn(0, 12)
  return

; Debug
Label23:
  debugFormatString = 
  (
    Analog Stick Coordinates: [{1}, {2}] ([{3}, {4}])
    Direction Buttons: (u/d/l/r/mx/my): {5}/{6}/{7}/{8}/{9}/{10}
    Action Buttons (A/B/L/R/X/Y/Z): {11}/{12}/{13}/{14}/{15}/{16}/{17}
    C Stick Coordinates: [{18}, {19}] ([{20}, {21}])
    C Buttons (Up/Down/Left/Right): {22}/{23}/{24}/{25}
  )
  coords := getAnalogCoords()
  convertedCoords := convertCoords(coords)
  cStickCoords := getCStickCoords()
  convertedCStickCoords := convertCoords(cStickCoords)
  debugString := Format(debugFormatString
    , coords[1], coords[2]
    , convertedCoords[1], convertedCoords[2]
    , buttonUp, buttonDown, buttonLeft, buttonRight, buttonModX, buttonModY
    , buttonA, buttonB, buttonL, buttonR, buttonX, buttonY, buttonZ
    , cStickCoords[1], cStickCoords[2]
    , convertedCStickCoords[1], convertedCStickCoords[2]
    , buttonCUp, buttonCDown, buttonCLeft, buttonCRight)
  Msgbox % debugString

Label23_UP:
  return

clearC() {
  buttonCUp := false
  buttonCDown := false
  buttonCLeft := false
  buttonCRight := false
}
