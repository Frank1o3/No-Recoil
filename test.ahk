#Include DECODER.ahk

name := "settings.txt"

Decoder.ReadFile(name)

data := Decoder.parse()

MsgBox data["Scar-H"][1]