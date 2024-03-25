#SingleInstance Force
InstallKeybdHook(true)
#Include JSON.ahk

; Tell the User the script settings
TrayTip "Script is running`nF1: Closes the Script`nF2 To open the Gui to select a gun", "Status"
SetTimer () => TrayTip(), -3000

; Variable setup
NormalZoomDelays := Array()
ZoomInDelays := Array()
Speeds := Array()
NormalDelay := 0
ZoomInDelay := 0
Drag := false
show := false
Delay := 0
Speed := 0

f := FileRead("GunNames.txt")
names := StrSplit(f, " ")
list := Array()

for name in names {
    name := String(name)
    list.__New(name)
    LoadVals(name)
}

MyGui := Gui(, "Gun's")
Option := MyGui.AddDropDownList("x5 y10 w100", list)
MyGui.AddText("x110 y7 w100 h35", "Select the gun you are using")
Option.OnEvent("Change", update)

SetTimer(main, 1)

#UseHook true
F1:: ExitApp()

F2::
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
    ; Toggle dragging state and simulate mouse down/up events.
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
    ; Change delay based on zooming state and simulate right mouse button down/up events.
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

; Disable the use of hooks for mouse and keyboard events.
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
    global MyGui, Speeds, ZoomInDelays, NormalZoomDelays, NormalDelay, ZoomInDelay, Speed
    local GunNum := thisGui.Value
    Speed := Speeds[GunNum]
    NormalDelay := NormalZoomDelays[GunNum]
    ZoomInDelay := ZoomInDelays[GunNum]
    Delay := NormalDelay
    MyGui.Submit(false)
}