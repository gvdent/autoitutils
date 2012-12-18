#cs
(c) 2012 Gijs van der Ent

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#ce

HotKeySet("{HOME}", "Start")                      ; Toggle recording mouse movements. Should not be neccessary.
HotKeySet("{END}", "Finish")                      ; Exit the recording script
HotKeySet("{PRINTSCREEN}", "WriteMouseMove")      ; Move the mouse to the current position
HotKeySet("{NUMPAD1}", "LeftClick")               ; Record a left click, but not the location
HotKeySet("{NUMPAD2}", "RightClick")              ; Record a right click, but not the location
HotKeySet("{NUMPAD4}", "MoveLeftClick")           ; Record a left click at the location
HotKeySet("{NUMPAD5}", "MoveRightClick")          ; Record a right click at the location

Global $file = FileOpen("MouseTrackOut.au3", 2)

; Note that this version is programmed to record window local coordinates.
; This can be changed by removing/altering the following lines.
Opt("MouseCoordMode", 2)
FileWriteLine($file, 'Opt("MouseCoordMode", 2)')

; Global state variables
Global $exit = 0 ; Exit the script
Global $stop = 0 ; Stop recording
Global $title = ""

Func Start()
   HotKeySet("{HOME}", "End")
   FileWriteLine($file, "; Starting recording")
   $stop = 0
   While $stop == 0
	  WriteMouseMove()
	  Sleep(100)
   WEnd
EndFunc

Func End()
   $stop = 1
   HotKeySet("{HOME}", "Start")
EndFunc

Func SetActiveWindow()
   Local $newTitle = WinGetTitle("[active]")
   If $title <> $newTitle Then
	  $title = $newTitle
	  FileWriteLine($file, 'WinActivate("' & $title & '")')
	  FileWriteLine($file, 'WinWaitActive("' & $title & '")')
   EndIf
EndFunc

Func WriteMouseMove()
   SetActiveWindow()
   Local $pos = MouseGetPos()
   FileWriteLine($file, "MouseMove(" & $pos[0] & ", " & $pos[1] & ")")
EndFunc

Func LeftClick()
   SetActiveWindow()
   MouseClick("left")
   FileWriteLine($file, 'MouseClick("left")')
EndFunc

Func RightClick()
   SetActiveWindow()
   MouseClick("right")
   FileWriteLine($file, 'MouseClick("right")')
EndFunc

Func MoveLeftClick()
   SetActiveWindow()
   Local $pos = MouseGetPos()
   MouseClick("left")
   FileWriteLine($file, 'MouseClick("left", ' & $pos[0] & ", " & $pos[1] & ")")
EndFunc

Func MoveRightClick()
   SetActiveWindow()
   Local $pos = MouseGetPos()
   MouseClick("right")
   FileWriteLine($file, 'MouseClick("right", ' & $pos[0] & ", " & $pos[1] & ")")
EndFunc

Func Finish()
   $exit = 1
EndFunc

; Loop until we need to exit
While $exit == 0
   Sleep(1000)
WEnd

FileClose($file)

