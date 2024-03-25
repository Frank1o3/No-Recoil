#SingleInstance Force

f := FileRead("settings.txt")

data := StrSplit(f,"`n")
for _,v in data {
    for _,e in StrSplit(v,A_Space) {
        if _ == 1 {
            name := StrReplace(e,"*","")
            MsgBox name
        }
    }
}
