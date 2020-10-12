#SingleInstance force
#NoEnv
#include <CvJoyInterface>
SetBatchLines, -1

hotkeys := [ "Analog Up"             ; 1
           , "Analog Down"           ; 2
           , "Analog Left"           ; 3
           , "Analog Right"          ; 4
           , "ModX"                  ; 5
           , "ModY"                  ; 6
           , "A"                     ; 7
           , "B"                     ; 8
           , "L"                     ; 9
           , "R"                     ; 10
           , "X"                     ; 11
           , "Y"                     ; 12
           , "Z"                     ; 13
           , "C-stick Up"            ; 14
           , "C-stick Down"          ; 15
           , "C-stick Left"          ; 16
           , "C-stick Right"         ; 17
           , "Lightshield (Light)"   ; 18
           , "Lightshield (Medium)"  ; 19
           , "Start"                 ; 20
           , "D-pad Up"              ; 21
           , "D-pad Down"            ; 22
           , "D-pad Left"            ; 23
           , "D-pad Right"           ; 24
           , "Debug"]                ; 25

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

buttonLSL := false
buttonLSM := false

buttonModX := false
buttonModY := false

buttonCUp := false
buttonCDown := false
buttonCLeft := false
buttonCRight := false

mostRecentVertical := ""
mostRecentHorizontal := ""

mostRecentVerticalC := ""
mostRecentHorizontalC := ""

simultaneousHorizontalModifierLockout := false

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

coordsRShieldVertical := [0, 0.5375]
coordsRShieldHorizontal := [0.6375, 0]
coordsRShieldQuadrant := [0.5375, 0.5375]
coordsRShieldQuadrantModX := [0.6375, 0.375]
coordsRShieldQuadrant12ModY := [0.4750, 0.8750]
coordsRShieldQuadrant34ModY := [0.5, 0.85]

coordsLZShieldVertical := coordsVertical
coordsLZShieldHorizontal := coordsHorizontal
coordsLZShieldQuadrant12 := coordsRShieldQuadrant
coordsLZShieldQuadrant34 := [0.7125, 0.6875]
coordsLZShieldQuadrantModX := coordsRShieldQuadrantModX
coordsLZShieldQuadrant12ModY := coordsRShieldQuadrant12ModY
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

; Debug info
lastCoordTrace := ""

; Utility functions

up() {
  global
  return buttonUp and mostRecentVertical == "U"
}

down() {
  global
  return buttonDown and mostRecentVertical == "D"
}

left() {
  global
  return buttonLeft and mostRecentHorizontal == "L"
}

right() {
  global
  return buttonRight and mostRecentHorizontal == "R"
}

cUp() {
  global
  return buttonCUp and mostRecentVerticalC == "U" and not bothMods()
}

cDown() {
  global
  return buttonCDown and mostRecentVerticalC == "D" and not bothMods()
}

cLeft() {
  global
  return buttonCLeft and mostRecentHorizontalC == "L" and not bothMods()
}

cRight() {
  global
  return buttonCRight and mostRecentHorizontalC == "R" and not bothMods()
}

modX() {
  global
  ; deactivate if either:
  ;   - modY is also held
  ;   - both left and right are held (and were pressed after modX) while neither up or down is active (
  return buttonModX and not buttonModY and not (simultaneousHorizontalModifierLockout and not anyVert()) 
}

modY() {
  global
  return buttonModY and not buttonModX and not (simultaneousHorizontalModifierLockout and not anyVert())
}

anyVert() {
  global
  return up() or down()
}

anyHoriz() {
  global
  return left() or right()
}

anyMod() {
  global
  return modX() or modY()
}

bothMods() {
  global
  return buttonModX and buttonModY
}

anyVertC() {
  global
  return cUp() or cDown()
}

anyHorizC() {
  global
  return cLeft() or cRight()
}

anyC() {
  global
  return cUp() or cDown() or cLeft() or cRight()
}

; Updates the position on the analog stick based on the current held buttons
updateAnalogStick() {
  setAnalogStick(getAnalogCoords())
}

updateCStick() {
  setCStick(getCStickCoords())
}

getAnalogCoords() {
  global
  if (anyMod() and (anyVert() and anyHoriz()) and (anyC() or buttonZ) and not (buttonL or buttonR or buttonLSL or buttonLSM)) {
    coords := getAnalogCoordsFirefox()
  } else if (buttonR) {
    coords := getAnalogCoordsWithR()
  } else if (buttonL or buttonZ or buttonLSL or buttonLSM) {
    coords := getAnalogCoordsWithLZ()
  } else {
    coords := getAnalogCoordsWithNoShield()
  }

  return reflectCoords(coords)
}

reflectCoords(coords) {
  x := coords[1]
  y := coords[2]
  if (down()) {
    y := -y
  }
  if (left()) {
    x := -x
  }
  return [x, y]
}

getAnalogCoordsWithR() {
  global
  if (neither(anyVert(), anyHoriz())) {
    lastCoordTrace := "R-O"
    return coordsOrigin
  } else if (anyVert() and anyHoriz()) {
    if (modX()) {
      lastCoordTrace := "R-Q-X"
      return coordsRShieldQuadrantModX
    } else if (modY()) {
      lastCoordTrace := "R-Q-Y"
      return up() ? coordsRShieldQuadrant12ModY : coordsRShieldQuadrant34ModY
    } else {
      lastCoordTrace := "R-Q"
      return coordsRShieldQuadrant
    }
  } else if (anyVert()) {
    lastCoordTrace := "R-V"
    return coordsRShieldVertical
  } else {
    lastCoordTrace := "R-H"
    return coordsRShieldHorizontal
  }
}

getAnalogCoordsWithLZ() {
  global
  if (neither(anyVert(), anyHoriz())) {
    lastCoordTrace := "L-O"
    return coordsOrigin
  } else if (anyVert() and anyHoriz()) {
    if (modX()) {
      lastCoordTrace := "L-Q-X"
      return coordsLZShieldQuadrantModX
    } else if (modY()) {
      lastCoordTrace := "L-Q-Y"
      return up() ? coordsLZShieldQuadrant12ModY : coordsLZShieldQuadrant34ModY
    } else {
      lastCoordTrace := "L-Q"
      return up() ? coordsLZShieldQuadrant12 : coordsLZShieldQuadrant34
    }
  } else if (anyVert()) {
    lastCoordTrace := "L-V"
    return coordsLZShieldVertical
  } else {
    lastCoordTrace := "L-H"
    return coordsLZShieldHorizontal
  }
}

getAnalogCoordsWithNoShield() {
  global
  if (neither(anyVert(), anyHoriz())) {
    lastCoordTrace := "N-O"
    return coordsOrigin
  } else if (anyVert() and anyHoriz()) {
    if (modX()) {
      lastCoordTrace := "N-Q-X"
      return coordsQuadrantModX
    } else if (modY()) {
      lastCoordTrace := "N-Q-Y"
      return coordsQuadrantModY
    } else {
      lastCoordTrace := "N-Q"
      return coordsQuadrant
    }
  } else if (anyVert()) {
    if (modX()) {
      lastCoordTrace := "N-V-X"
      return coordsVerticalModX
    } else if (modY()) {
      lastCoordTrace := "N-V-Y"
      return coordsVerticalModY
    } else {
      lastCoordTrace := "N-V"
      return coordsVertical
    }
  } else {
    if (modX()) {
      lastCoordTrace := "N-H-X"
      return coordsHorizontalModX
    } else if (modY()) {
      lastCoordTrace := "N-H-Y"
      return buttonB ? coordsHorizontal : coordsHorizontalModY ; turnaround side-b nerf
    } else {
      lastCoordTrace := "N-H"
      return coordsHorizontal
    }
  }
}

getAnalogCoordsFirefox() {
  global
  if (modX()) {
    if (cUp()) {
      lastCoordTrace := "F-X-U"
      return buttonZ ? coordsExtendedFirefoxModXCUp : coordsFirefoxModXCUp
    } else if (cDown()) {
      lastCoordTrace := "F-X-D"
      return buttonZ ? coordsExtendedFirefoxModXCDown : coordsFirefoxModXCDown
    } else if (cLeft()) {
      lastCoordTrace := "F-X-L"
      return buttonZ ? coordsExtendedFirefoxModXCLeft : coordsFirefoxModXCLeft
    } else if (cRight()) {
      lastCoordTrace := "F-X-R"
      return buttonZ ? coordsExtendedFirefoxModXCRight : coordsFirefoxModXCRight
    }
  } else if (modY()) {
    if (cUp()) {
      lastCoordTrace := "F-Y-U"
      return buttonZ ? coordsExtendedFirefoxModYCUp : coordsFirefoxModYCUp
    } else if (cDown()) {
      lastCoordTrace := "F-Y-D"
      return buttonZ ? coordsExtendedFirefoxModYCDown : coordsFirefoxModYCDown
    } else if (cLeft()) {
      lastCoordTrace := "F-Y-L"
      return buttonZ ? coordsExtendedFirefoxModYCLeft : coordsFirefoxModYCLeft
    } else if (cRight()) {
      lastCoordTrace := "F-Y-R"
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
  if (neither(anyVertC(), anyHorizC())) {
    coords := [0, 0]
  } else if (anyVertC() and anyHorizC()) {
    coords := [0.525, 0.85]
  } else if (anyVertC()) {
      coords := [0, 1]
  } else {
    if (modX() and up()) {
      coords := [0.9, 0.5]
    } else if (modX() and down()) {
      coords := [0.9, -0.5]
    } else {
      coords := [1, 0]
    }
  }

  return reflectCStickCoords(coords)
}

reflectCStickCoords(coords) {
  x := coords[1]
  y := coords[2]
  if (cDown()) {
    y := -y
  }
  if (cLeft()) {
    x := -x
  }
  return [x, y]
}

setCStick(coords) {
  global
  convertedCoords := convertCoords(coords)
  myStick.SetAxisByIndex(convertedCoords[1], 4)
  myStick.SetAxisByIndex(convertedCoords[2], 5)
}

; Converts coordinates from melee values (-1 to 1) to vJoy values (0 to 32767).
convertCoords(coords) {
  mx = 10271 ; Why this number? idk, I would have thought it should be 16384 * (80 / 128) = 10240, but this works
  my = -10271
  bx = 16448 ; 16384 + 64
  by = 16320 ; 16384 - 64
  return [ mx * coords[1] + bx
         , my * coords[2] + by ]
}

setAnalogR(value) {
  global
  ; vJoy/Dolphin does something strange with rounding analog shoulder presses. In general,
  ; it seems to want to round to odd values, so
  ;   16384 => 0.00000 (0)   <-- actual value used for 0
  ;   19532 => 0.35000 (49)  <-- actual value used for 49
  ;   22424 => 0.67875 (95)  <-- actual value used for 94
  ;   22384 => 0.67875 (95)
  ;   22383 => 0.66429 (93)
  ; But, *extremely* inconsistently, I have seen the following:
  ;   22464 => 0.67143 (94)
  ; Which no sense and I can't reproduce. 
  convertedValue := 16384 * (1 + (value  / 255))
  myStick.SetAxisByIndex(convertedValue, 3)
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
  updateCStick()
  return

Label1_UP:
  buttonUp := false
  updateAnalogStick()
  updateCStick()
  return

; Analog Down
Label2:
  buttonDown := true
  mostRecentVertical := "D"
  updateAnalogStick()
  updateCStick()
  return

Label2_UP:
  buttonDown := false
  updateAnalogStick()
  updateCStick()
  return

; Analog Left
Label3:
  buttonLeft := true
  mostRecentHorizontal := "L"
  if (buttonRight) {
    simultaneousHorizontalModifierLockout := true
  }
  updateAnalogStick()
  return

Label3_UP:
  buttonLeft := false
  simultaneousHorizontalModifierLockout := false
  updateAnalogStick()
  return

; Analog Right
Label4:
  buttonRight := true
  mostRecentHorizontal := "R"
  if (buttonLeft) {
    simultaneousHorizontalModifierLockout := true
  }
  updateAnalogStick()
  return

Label4_UP:
  buttonRight := false
  simultaneousHorizontalModifierLockout := false
  updateAnalogStick()
  return

; ModX
Label5:
  buttonModX := true
  simultaneousHorizontalModifierLockout := false ; Lockout is order dependant, only applies if modifier isn't pressed after horizontals
  updateAnalogStick()
  updateCStick()
  return

Label5_UP:
  buttonModX := false
  simultaneousHorizontalModifierLockout := false
  updateAnalogStick()
  updateCStick()
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
  buttonCUp := true
  if (bothMods()) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 9)
  } else {
    mostRecentVerticalC := "U"
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
  buttonCDown := true
  if (bothMods()) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 11)
  } else {
    mostRecentVerticalC := "D"
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
  buttonCLeft := true
  if (bothMods()) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 10)
  } else {
    mostRecentHorizontalC := "L"
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
  buttonCRight := true
  if (bothMods()) {
    ; Pressing ModX and ModY simultaneously changes C buttons to D pad
    myStick.SetBtn(1, 12)
  } else {
    mostRecentHorizontalC := "R"
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

; Lightshield (Light)
Label18:
  buttonLSL := true
  setAnalogR(49)
  return

Label18_UP:
  buttonLSL := false
  setAnalogR(0)
  return

; Lightshield (Medium)
Label19:
  buttonLSM := true
  setAnalogR(94)
  return

Label19_UP:
  buttonLSM := false
  setAnalogR(0)
  return

; Start
Label20:
  myStick.SetBtn(1, 8)
  return

Label20_UP:
  myStick.SetBtn(0, 8)
  return

; D Up
Label21:
  myStick.SetBtn(1, 9)
  return

Label21_UP:
  myStick.SetBtn(0, 9)
  return

; D Down
Label22:
  myStick.SetBtn(1, 11)
  return

Label22_UP:
  myStick.SetBtn(0, 11)
  return

; D Left
Label23:
  myStick.SetBtn(1, 10)
  return

Label23_UP:
  myStick.SetBtn(0, 10)
  return

; D Right
Label24:
  myStick.SetBtn(1, 12)
  return

Label24_UP:
  myStick.SetBtn(0, 12)
  return

; Debug
Label25:
  debugString := getDebug()
  Msgbox % debugString

Label25_UP:
  return

getDebug() {
  global
  activeArray := []
  pressedArray := []
  flagArray := []

  appendButtonState(activeArray, pressedArray, up(), buttonUp, "Up")
  appendButtonState(activeArray, pressedArray, down(), buttonDown, "Down")
  appendButtonState(activeArray, pressedArray, left(), buttonLeft, "Left")
  appendButtonState(activeArray, pressedArray, right(), buttonRight, "Right")

  appendButtonState(activeArray, pressedArray, modX(), buttonModX, "ModX")
  appendButtonState(activeArray, pressedArray, modY(), buttonModY, "ModY")

  appendButtonState(activeArray, pressedArray, buttonA, false, "A")
  appendButtonState(activeArray, pressedArray, buttonB, false, "B")
  appendButtonState(activeArray, pressedArray, buttonL, false, "L")
  appendButtonState(activeArray, pressedArray, buttonR, false, "R")
  appendButtonState(activeArray, pressedArray, buttonX, false, "X")
  appendButtonState(activeArray, pressedArray, buttonY, false, "Y")
  appendButtonState(activeArray, pressedArray, buttonZ, false, "Z")

  appendButtonState(activeArray, pressedArray, buttonLSL, false, "LS1")
  appendButtonState(activeArray, pressedArray, buttonLSM, false, "LS2")

  appendButtonState(activeArray, pressedArray, CUp(), buttonCUp, "C-Up")
  appendButtonState(activeArray, pressedArray, CDown(), buttonCDown, "C-Down")
  appendButtonState(activeArray, pressedArray, CLeft(), buttonCLeft, "C-Left")
  appendButtonState(activeArray, pressedArray, CRight(), buttonCRight, "C-Right")

  conditionalAppend(flagArray, simultaneousHorizontalModifierLockout, "SHML")

  activeButtonList := stringJoin(", ", activeArray)
  pressedButtonList := stringJoin(", ", pressedArray)
  flagList := stringJoin(", ", flagArray)

  trace1 := lastCoordTrace

  analogCoords := getAnalogCoords()
  cStickCoords := getCStickCoords()

  trace2 := lastCoordTrace

  trace := trace1 == trace2 ? trace1 : Format("{1}/{2}", trace1, trace2)

  debugFormatString = 
  (

    Analog Stick: [{1}, {2}]
    C Stick: [{3}, {4}]

    Active held buttons:
        {5}

    Disabled held buttons:
        {6}

    Flags:
        {7}

    Trace:
        {8}

  )

  return Format(debugFormatString
    , analogCoords[1], analogCoords[2]
    , cStickCoords[1], cStickCoords[2]
    , activeButtonList, pressedButtonList, flagList
    , trace)
}

appendButtonState(activeArray, pressedArray, isActive, isPressed, name) {
  if (isActive) {
    activeArray.Push(name)
  } else if (isPressed) {
    pressedArray.Push(name)
  }
}

conditionalAppend(array, condition, value) {
  if (condition) {
    array.Push(value)
  }
}

; From https://www.autohotkey.com/boards/viewtopic.php?t=7124
stringJoin(sep, params) {
    for index,param in params
        str .= param . sep
    return SubStr(str, 1, -StrLen(sep))
}
