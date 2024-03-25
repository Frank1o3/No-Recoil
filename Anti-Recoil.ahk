#SingleInstance Force
InstallKeybdHook(true)
#Include JSON.ahk

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is running`nF3: Closes the Script.`nF2: Reload's the Script.`nF1: To open the Gui.", "Status"
SetTimer () => TrayTip(), -8000 ; Sets a timer to periodically show the tray tip.

Guns := SmartRead()
Selected := Array([0,0,0],[0,0,0])
Primary := 1
Drag := false
Show := false
Delay := 0

MyGui := Gui()
Option1 := MyGui.AddDropDownList("x5 y10 w140", Guns[1])
MyGui.AddText("x150 y10 w150 h30", "Select Your Primary Gun.")
Option2 := MyGui.AddDropDownList("x5 y40 w140", Guns[2])
MyGui.AddText("x150 y40 w150 h30", "Select Your Secondary Gun.")

Option1.OnEvent("Change", Update1)
Option2.OnEvent("Change", Update2)

SetTimer(main, 1)

#UseHook true
F3:: ExitApp(0)
F2:: Reload()

#HotIf WinActive('Roblox')
F1::
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
WheelUp:: {
    global Primary
    switch A_ThisHotkey {
        case "LButton":
            Send("{WheelDown Down}")
            if (Primary == 1) {
                Primary := 2
            } else {
                Primary := 1
            }
            Sleep 100
        case "LButton Up":
            Send("{WheelDown Up}")
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
    global Selected, Primary, Delay
    switch A_ThisHotkey {
        case "RButton":
            Delay := Selected[Primary][2]
            Click("Right Down")
        case "RButton Up":
            DDelay := Selected[Primary][1]
            Click("Right Up")
    }
}

#UseHook false

main() {
    global Drag, Delay, Primary, Selected
    ToolTip Primary ? "Primary":"Secondary"
    if (Drag) {
        DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Selected[Primary][3])
        Sleep Delay
    }
}

Update1(thisGui,*) {
    global Guns, Selected
    local args := []
    local name := Guns[1][thisGui.Value]
    local f := FileRead("settings.json")
    local data := JSON.parse(f)
    for Key, value in data[name] {
        if Key == "Delay1" {
            args.__New(value)
        } else if Key == "Delay2" {
            args.__New(value)
        } else if Key == "Speed" {
            args.__New(value)
        }
    }
    Selected.InsertAt(1,args)
}

Update2(thisGui,*) {
    global Guns, Selected
    local args := []
    local name := Guns[2][thisGui.Value]
    local f := FileRead("settings.json")
    local data := JSON.parse(f)
    for Key, value in data[name] {
        if Key == "Delay1" {
            args.__New(value)
        } else if Key == "Delay2" {
            args.__New(value)
        } else if Key == "Speed" {
            args.__New(value)
        }
    }
    Selected.InsertAt(2,args)
}

SmartRead() {
    local f := FileRead("GunNames.txt")
    local data := StrSplit(f,"`n")
    local PrimaryGuns := Array()
    local SecondaryGuns := Array()
    for _,v in data {
        local GunType := SubStr(v,1,9)
        GunType := StrReplace(GunType,A_Space,"")
        if GunType == "Primary" {
            for _,v in StrSplit(v,A_Space) {
                if v != "Primary" && v != "" {
                    PrimaryGuns.__New(v)
                }
            }
        } else if GunType == "Secondary" {
            for _,v in StrSplit(v,A_Space) {
                if v != "Secondary" && v != "" {
                    SecondaryGuns.__New(v)
                }
            }
        }
    }
    return [PrimaryGuns,SecondaryGuns]
}