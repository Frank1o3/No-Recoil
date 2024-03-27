#Include DECODER.ahk

name := "settings.txt"

Decoder.ReadFile(name)

names := Decoder.GetNames()

data := Decoder.parse()

MsgBox names[1]

MsgBox data[names.Get(1)][1]