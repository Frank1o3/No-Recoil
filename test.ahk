#SingleInstance Force
InstallKeybdHook(true)

nameLen := 7
f := FileRead("settings.txt")
Enabled := false

; Displays a tray tip to inform the user about the script's status and hotkeys.
TrayTip "Script is Running...", "Status Report"
SetTimer () => TrayTip(), -1000
Sleep 1500
TrayTip "F4: Closes the Script.`nF3: Reload's the Script.`nF2: Enable/Disable the Script`nF1: Open's Gui", "Key binds"
SetTimer () => TrayTip(), -10000 ; Sets a timer to periodically show the tray tip.



; Functions

GetName(data, line) {
    global nameLen 
    a := StrSplit(data, "`n")
    sub := SubStr(a[line],1,nameLen)
    return StrReplace(sub,"*","")
}

parse(data) {
    global nameLen
    name := ""
    a := StrSplit(data, "`n")
    out := Array()
    tree := Map()
    for _, b in a {
        for _, c in StrSplit(b, A_Space) {
            if _ == 1 {
                
            }
            if _ == 2 {
                name := StrReplace(c, "*", "")
            } else if _ == 3 {
                d := StrSplit(c, ":")
                d := StrReplace(d[2], "+", "")
                out.__New(d)
            }
            else if _ == 4 {
                d := StrSplit(c, ":")
                d := StrReplace(d[2], "+", "")
                out.__New(d)
            }
            else if _ == 5 {
                d := StrSplit(c, ":")
                d := StrReplace(d[2], "+", "")
                out.__New(d)
            }
        }
        tree.__New(name, out)
        out := []
    }
    return tree
}