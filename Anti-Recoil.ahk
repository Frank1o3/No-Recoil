#SingleInstance Force
InstallKeybdHook(true)
#Include JSON.ahk

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is running`nF4: Closes the Script.`nF3: Reload's the Script.`nF2: Enable/Disable the Script`nF1: To open the Gui.", "Status"
SetTimer () => TrayTip(), -8000 ; Sets a timer to periodically show the tray tip.

Selected := Array([0,0,0],[0,0,0])
Guns := SmartRead()
Enabled := false
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
F4:: ExitApp(0)
F3:: Reload()

F2:: {

}

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
WheelUp::
WheelUp Up::
{
    global Primary, Enabled
    switch A_ThisHotkey {
        case "WheelUp":
            if !Enabled {
                Send("{WheelUp Down}")
                return
            }
            Send("{WheelDown Down}")
            if (Primary == 1) {
                Primary := 2
            } else {
                Primary := 1
            }
            Sleep 100
        case "WheelUp Up":
            if !Enabled {
                Send("{WheelUp Up}")
                return
            }
            Send("{WheelDown Up}")
    }
}

#HotIf WinActive('Roblox')
LButton::
LButton Up::
{
    ; Toggles the dragging state and simulates mouse down/up events.
    global Drag, Enabled
    if !Enabled {
        return
    }
    switch A_ThisHotkey {
        case "LButton":
            Click "Down"
            if !Enabled {
                return
            }
            Drag := true
        case "LButton Up":
            Click "Up"
            if !Enabled {
                return
            }
            Drag := false
    }
}

#HotIf WinActive('Roblox')
RButton::
RButton Up::
{
    ; Changes the delay based on zooming state and simulates right mouse button down/up events.
    global Selected, Primary, Delay, Enabled
    if !Enabled {
        return
    }
    switch A_ThisHotkey {
        case "RButton":
            Click("Right Down")
            if !Enabled {
                return
            }
            Delay := Selected[Primary][2]
        case "RButton Up":
            Click("Right Up")
            if !Enabled {
                return
            }
            Delay := Selected[Primary][1]
    }
}

#UseHook false

main() {
    global Drag, Delay, Primary, Selected, Enabled
    if !Enabled {
        return
    }
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