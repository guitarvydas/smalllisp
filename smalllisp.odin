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

GetFirstByte :: proc (p : Ptr) -> byte {
    p := mem [p + offset]
    a := transmute ([2]byte) p
    return a[0]
}

GetSecondByte :: proc (p : Ptr) -> byte {
    p := mem [p + offset]
    a := transmute ([2]byte) p
    return a[1]
}

AllocAtom :: proc () -> Ptr {
    fmt.assertf ((nextAtom + offset) > 0, "out of (atom) memory\n")
    r := nextAtom
    nextAtom = nextAtom - CellLength
    fmt.printf ("AllocAtom %v (next=%v)\n", r, nextAtom)
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

