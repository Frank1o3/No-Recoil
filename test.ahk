name := "settings.txt"

data := read(name)

read(fileName) {
    loop read fileName {
        local content := StrReplace(A_LoopReadLine, '`n', '')
        local GunType := SubStr(content, 1, 9)
        local GunName := SubStr(content, 10, 19)
        local Option := StrSplit(content, '+')[2]
        local SubOptions := StrSplit(Option, A_Space)

        content := StrReplace(content, '*', '')
        GunType := StrReplace(GunType, '*', '') 
        GunName := StrReplace(GunName, '*', '')
        distance := Float(SubOptions[1])
        Delay1 := Number(SubOptions[2])
        Delay2 := Number(SubOptions[3])
        MsgBox Delay2
    }
    return 0
}