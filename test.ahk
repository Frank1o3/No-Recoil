#SingleInstance Force


f := FileRead("settings.txt")
data := StrSplit(f, "`n")

parse(date) {
    a := StrSplit(date, "`n")
    out := []
    for _, b in a {
        for _, c in StrSplit(b, A_Space) {
            if _ == 1 {
                name := StrReplace(c, "*", "")
                MsgBox name
            } else if _ == 2 {
                d := StrSplit(c, ":")
                speed := d[2]
            }
            else if _ == 3 {
                d := StrSplit(c, ":")
                Delay1 := d[2]
            }
            else if _ == 4 {
                d := StrSplit(c, ":")
                Delay2 := d[2]
            }
        }
    }
}