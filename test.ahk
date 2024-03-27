#Include DECODER.ahk

name := "settings.txt"

Decoder.ReadFile(name)

Guns := Decoder.GetTypes()

data := Decoder.parse()

MsgBox Guns[1][2]

MsgBox data[Guns.Get(1)[2]][1]