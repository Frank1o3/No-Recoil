
class Decoder {
    static content := Array()
    static fileName := String("")

    static ReadFile(fileName) {
        this.fileName := fileName 
        local data := FileRead(fileName)
        data := StrSplit(data,'`n')
        this.content := data
    }
    static GetNames() {
        tree := Array()
        for i, line in this.content {
            parts := StrSplit(line, ' ')
            GunName := StrReplace(parts[2],'*','')
            tree.__New(GunName)
        }
        return tree
    }
    static GetTypes() {
        tree := Array()
        for i, line in this.content {
            parts := StrSplit(line, ' ')
            GunType := StrReplace(parts[1],'*','')
            GunName := StrReplace(parts[2],'*','')=
            tree.__New([GunType,GunName])
        }
        return tree
    }
    static parse() {
        tree := Map()
        for i, line in this.content {
            parts := StrSplit(line, ' ')
            GunType := StrReplace(parts[1],'*','')
            GunName := StrReplace(parts[2],'*','')
            Options := StrSplit(parts[3], '+')
            tree[GunName] := Options
        }
        return tree
    }
}