package smalllisp

import "core:fmt"
import "core:strings"



Set :: proc (p : Ptr, v : Ptr) { mem [p + offset] = v }
Get :: proc (p : Ptr) -> Ptr { return mem [p + offset] }
Car :: proc (p : Ptr) -> Ptr { return Get (p) }
Cdr :: proc (p : Ptr) -> Ptr { return Get (p + 1) }
List :: proc (p : Ptr) -> bool { return p >= offset }
Atom :: proc (p : Ptr) -> bool { return p < offset }
Null :: proc (p : Ptr) -> bool { return p == offset }


nextAtom : Ptr = FIRSTAtom
nextList : Ptr = FIRSTList

mem := [MemSize]Ptr{}

GetByte :: proc (p : Ptr) -> byte {
    return cast (byte) mem [p + offset]
}

SetByte :: proc (p : Ptr, v : byte) {
    mem [p + offset] = cast (Ptr) v
}

AllocAtom :: proc () -> Ptr {
    fmt.assertf ((nextAtom + offset) > 0, "out of (atom) memory\n")
    r := nextAtom
    nextAtom = nextAtom - CellLength
    return r
}

AllocList :: proc () -> Ptr { 
    fmt.assertf ((nextList + offset) < len (mem) - lisp_nil, "out of (list) memory\n")
    r := nextList
    nextList = nextList + CellLength
    return r
}

Cons :: proc (left : Ptr, right : Ptr) -> Ptr {
    p := AllocList ()
    Set (p, left)
    Set (p + 1, right)
    return p
}

