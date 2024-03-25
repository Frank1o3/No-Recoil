#SingleInstance Force


f := FileRead("settings.txt")

data := parse(f)
MsgBox GetName(f,1) 
MsgBox data["Scar-H"][1]

GetName(data, line) {
    a := StrSplit(data, "`n")
    sub := SubStr(a[line],1,7)
    return StrReplace(sub,"*","")
}

parse(data) {
    name := ""
    a := StrSplit(data, "`n")
    out := Array()
    tree := Map()
    for _, b in a {
        for _, c in StrSplit(b, A_Space) {
            if _ == 1 {
                name := StrReplace(c, "*", "")
            } else if _ == 2 {
                d := StrSplit(c, ":")
                d := StrReplace(d[2], "+", "")
                out.__New(d)
            }
            else if _ == 3 {
                d := StrSplit(c, ":")
                d := StrReplace(d[2], "+", "")
                out.__New(d)
            }
            else if _ == 4 {
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