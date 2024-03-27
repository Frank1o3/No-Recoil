
class Decoder {
    static content := Array()
    static fileName := String("")

    static ReadFile(fileName) {
        this.fileName := fileName 
        local data := FileRead(fileName)
        data := StrReplace(data,'*','')
        data := StrSplit(data,'`n')
        this.content := data
    }
    static GetNames() {
        tree := Array()
        for v in this.content {
            GunName := SubStr(v,10,19)
            tree.__New(GunName)
        }
    }
    static parse() {
        tree := Map()
        i := 1
        MsgBox this.content.Length
        while 1 < this.content.Length {
            GunType := SubStr(this.content[i],1,9)
            GunName := SubStr(this.content[i],10,19)
            Options := StrSplit(this.content[i],'+')
            Options := StrSplit(Options[2],A_Space)
            tree.__New(GunName,Options)
            if tree.Has(GunName) {
                i +=1
            }
            if i > this.content.Length {
                return
            }
            Sleep 100
        }
        return tree
    }
}