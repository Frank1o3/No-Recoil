#SingleInstance Force
InstallKeybdHook(true)

nameLen := 9
f := FileRead("settings.txt")
Enabled := false

data := parse(f)

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is Running...", "Status Report"
SetTimer () => TrayTip(), -1000
Sleep 2000
TrayTip "F4: Closes the Script.`nF3: Reload's the Script.`nF2: Enable/Disable the Script`nF1: Open's Gui", "Key binds"
SetTimer () => TrayTip(), -10000 ; Sets a timer to periodically show the tray tip.

Primary := 1
Selected := ["",""]
Drag := false
Show := false
Delay := 0

MyGui := Gui()
Option1 := MyGui.AddDropDownList("x5 y10 w140 Choose2", GetNames(f,"Primary"))
MyGui.AddText("x150 y10 w150 h30", "Select Your Primary Gun.")
Option2 := MyGui.AddDropDownList("x5 y40 w140 Choose1", GetNames(f,"Secondary"))
MyGui.AddText("x150 y40 w150 h30", "Select Your Secondary Gun.")
MyGui.AddText("x5 y80 w150 h30", "Do not leave the option's empty the script will break")
MyGui.Show()

Option1.OnEvent("Change", Update1)
Option2.OnEvent("Change", Update2)

; HotKeys

#UseHook true

F4::ExitApp()
F3::Reload()

#HotIf WinActive('Roblox')
F2:: {
    global Enabled
    Enabled := !Enabled
    Sleep 100
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

#UseHook false

; Functions

Update1(thisGui,*) {
    global Selected
    Selected[1] := thisGui.Text
}

Update2(thisGui,*) {
    global Selected
    Selected[2] := thisGui.Text
}

GetNames(data,type) {
    global nameLen
    out := Array()
    a := StrSplit(data, "`n")
    for _,l in a {
        b := StrSplit(l,A_Space)
        t := StrReplace(b[1],"*","")
        if t == type {
            out.__New(StrReplace(b[2],"*",""))
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
        GunType := StrReplace(data[1], "*", "")
        name := StrReplace(data[2], "*", "")
        if (GunType == "Primary") {
            speed := StrSplit(data[3],":")[2]
            speed := StrReplace(speed,"+","")
            Delay1 := StrSplit(data[4],":")[2]
            Delay1 := StrReplace(Delay1,"+","")
            Delay2 := StrSplit(data[5],":")[2]
            Delay2 := StrReplace(Delay2,"+","")
            base.__New(name, [speed, Delay1, Delay2])
        }
        out.Set("Primary",base)
    }
    GunType := ""
    base := Map()
    name := ""
    for b in a {
        data := StrSplit(b, A_Space)
        GunType := StrReplace(data[1], "*", "")
        name := StrReplace(data[2], "*", "")
        if (GunType == "Secondary") {
            speed := StrSplit(data[3],":")[2]
            speed := StrReplace(speed,"+","")
            Delay1 := StrSplit(data[4],":")[2]
            Delay1 := StrReplace(Delay1,"+","")
            Delay2 := StrSplit(data[5],":")[2]
            Delay2 := StrReplace(Delay2,"+","")
            base.__New(name, [speed, Delay1, Delay2])
        }
        out.Set("Secondary",base)
    }
    GunType := ""
    base := Map()
    name := ""
    return out
}