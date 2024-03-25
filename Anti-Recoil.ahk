#SingleInstance Force ; Ensures only one instance of the script runs at a time.
InstallKeybdHook(true) ; Installs a keyboard hook to detect key presses.
#Include JSON.ahk ; Includes the JSON library for parsing JSON files.

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is running`nF1: Closes the Script`nF2 To open the Gui to select a gun", "Status"
SetTimer () => TrayTip(), -3000 ; Sets a timer to periodically show the tray tip.

; Initializes arrays and variables for managing delays, speeds, and dragging state.
NormalZoomDelays := Array()
ZoomInDelays := Array()
Speeds := Array()
NormalDelay := 0
ZoomInDelay := 0
Drag := false
show := false
Delay := 0
Speed := 0

; Reads gun names from a file and loads their settings.
f := FileRead("GunNames.txt")
names := StrSplit(f, " ")
list := Array()

for name in names {
    name := String(name)
    list.__New(name)
    LoadVals(name)
}

; Creates a GUI for selecting a gun.
MyGui := Gui(, "Gun's Options")
Option := MyGui.AddDropDownList("x5 y10 w140", list)
MyGui.AddText("w150 y10 w150 h30", "Select the gun you are using")
Option.OnEvent("Change", update)

SetTimer(main, 1) ; Sets a timer to call the main function every millisecond.

#UseHook true ; Enables the use of hooks for mouse and keyboard events.
F1::ExitApp() ; Defines a hotkey to exit the script.

#HotIf WinActive('Roblox') ; Ensures the following hotkeys only work when Roblox is the active window.
F2:: ; Defines a hotkey to show/hide the GUI.
{
    global show
    if show {
        MyGui.Hide()
        show := false
        Sleep 500
        return
    }
    else {
        MyGui.Show()
        show := true
        Sleep 500
        return
    }
}

#HotIf WinActive('Roblox')
LButton::
LButton Up::
{
    ; Toggles the dragging state and simulates mouse down/up events.
    global Drag
    switch A_ThisHotkey {
        case "LButton":
            Click "Down"
            Drag := true
        case "LButton Up":
            Click "Up"
            Drag := false
    }
}

#HotIf WinActive('Roblox')
RButton::
RButton Up::
{
    ; Changes the delay based on zooming state and simulates right mouse button down/up events.
    global Delay
    switch A_ThisHotkey {
        case "RButton":
            Delay := ZoomInDelay
            Click("Right Down")
        case "RButton Up":
            Delay := NormalDelay
            Click("Right Up")
    }
}

; Disables the use of hooks for mouse and keyboard events.
#UseHook false

; Main function that is called every millisecond. If dragging is active, it simulates a mouse event with the specified speed and delay.
main() {
    global Drag, Speed, Delay
    if (Drag && Speed != 0 && Delay != 0) {
        DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Speed)
        Sleep Delay
    }
}

; Functions

LoadVals(gunName) {
    ; Loads settings for a specific gun from a JSON file.
    global NormalZoomDelays, ZoomInDelays, Speeds
    local f := FileRead("settings.json")
    local data := JSON.parse(f)
    for Key, v in data[gunName] {
        if Key == "Delay1" {
            NormalZoomDelays.__New(v)
        } else if Key == "Delay2" {
            ZoomInDelays.__New(v)
        } else if Key == "Speed" {
            Speeds.__New(v)
        }
    }
}

update(thisGui, *) {
    ; Updates the script's settings based on the selected gun in the GUI.
    global MyGui, Speeds, ZoomInDelays, NormalZoomDelays, NormalDelay, ZoomInDelay, Speed
    local GunNum := thisGui.Value
    Speed := Speeds[GunNum]
    NormalDelay := NormalZoomDelays[GunNum]
    ZoomInDelay := ZoomInDelays[GunNum]
    Delay := NormalDelay
    MyGui.Submit(false)
}