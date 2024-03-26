#SingleInstance Force
InstallKeybdHook(true)

nameLen := 9
f := FileRead("settings.txt")
Enabled := false
Primary := 1
Selected := ["", ""]
Drag := false
Show := false
ZoomIn := 2
delay := 0

data := parse(f)

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is Running...", "Status Report"
SetTimer () => TrayTip(), -1000
Sleep 2000
TrayTip "F4: Closes the Script.`nF3: Reload's the Script.`nF2: Enable/Disable the Script`nF1: Open's Gui", "Key binds"
SetTimer () => TrayTip(), -10000 ; Sets a timer to periodically show the tray tip.

MyGui := Gui()
Option1 := MyGui.AddDropDownList("x5 y10 w140", GetNames(f, "Primary"))
MyGui.AddText("x150 y10 w150 h30", "Select Your Primary Gun.")
Option2 := MyGui.AddDropDownList("x5 y40 w140", GetNames(f, "Secondary"))
MyGui.AddText("x150 y40 w150 h30", "Select Your Secondary Gun.")
MyGui.AddText("x5 y80 w150 h30", "Do not leave the option's empty the script will break")

Option1.OnEvent("Change", Update1)
Option2.OnEvent("Change", Update2)

; Setup Main Loop
SetTimer(Main, 1)

; HotKeys

#UseHook true

F4:: ExitApp()
F3:: Reload()

#HotIf WinActive('Roblox')
F2:: {
    global Enabled
    Enabled := !Enabled
    Sleep 100
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
{
    global Primary, Enabled
    if !Enabled {
        return
    }
    if (Primary == 1) {
        Primary := 2
    } else {
        Primary := 1
    }
    Send("{WheelDown Down}")
    Sleep 500
    Send("{WheelDown Up}")
    Sleep 500
}

#HotIf WinActive('Roblox')
LButton::
LButton Up::
{
    ; Toggles the dragging state and simulates mouse down/up events.
    global Drag, Enabled
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
    global Enabled, ZoomIn
    switch A_ThisHotkey {
        case "RButton":
            Click("Right Down")
            if !Enabled {
                return
            }
            ZoomIn := 3
        case "RButton Up":
            Click("Right Up")
            if !Enabled {
                return
            }
            ZoomIn := 2
    }
}

; Functions

Update1(thisGui, *) {
    global Selected, delay, Primary, ZoomIn
    Selected[1] := thisGui.Text
    t := (Primary == 1) ? "Primary" : "Secondary"
    delay := data.Get(t)[thisGui.Text][ZoomIn]
}

Update2(thisGui, *) {
    global Selected
    Selected[2] := thisGui.Text
}

Main() {
    global Enabled, Selected, data, Drag, ZoomIn, Primary, delay
    if !Enabled {
        return
    }
    ToolTip (Primary == 1) ? "Primary" : "Secondary"
    if GetKeyState("F", "P") {
        Primary := 1
    }
    if Drag {
        t := (Primary == 1) ? "Primary" : "Secondary"
        DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", data.Get(t)[Selected.Get(Primary)][1])
        Sleep delay
    }
}

GetNames(data, type) {
    global nameLen
    out := Array()
    a := StrSplit(data, "`n")
    for _, l in a {
        b := StrSplit(l, A_Space)
        t := StrReplace(b[1], "*", "")
        if t == type {
            out.__New(StrReplace(b[2], "*", ""))
        }
    }
    return out
}

parse(data) {
    global nameLen
    name := ""
    GunType := ""
    a := StrSplit(data, "`n")
    base := Map()
    out := Map()
    for b in a {
        data := StrSplit(b, A_Space)
        if InStr(data[1],"+") {
            return
        }
        GunType := StrReplace(data[1], "*", "")
        name := StrReplace(data[2], "*", "")
        if (GunType == "Primary") {
            speed := StrReplace(data[3], "*", "")
            Delay1 := StrReplace(data[4], "*", "")
            Delay2 := StrReplace(data[5], "*", "")
            base.__New(name, [speed, Delay1, Delay2])
        }
        out.Set("Primary", base)
    }
    GunType := ""
    base := Map()
    name := ""
    for b in a {
        data := StrSplit(b, A_Space)
        if InStr(data[1],"+") {
            return
        }
        GunType := StrReplace(data[1], "*", "")
        name := StrReplace(data[2], "*", "")
        if (GunType == "Secondary") {
            speed := StrReplace(data[3], "*", "")
            Delay1 := StrReplace(data[4], "*", "")
            Delay2 := StrReplace(data[5], "*", "")
            base.__New(name, [speed, Delay1, Delay2])
        }
        out.Set("Secondary", base)
    }
    GunType := ""
    base := Map()
    name := ""
    return out
}