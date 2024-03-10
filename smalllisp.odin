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

GetByte :: proc (p : Ptr) -> byte {
    return cast (byte) mem [p + offset]
}

SetByte :: proc (p : Ptr, v : byte) {
    mem [p + offset] = cast (Ptr) v
}

AllocAtom :: proc () -> Ptr {
    fmt.assertf (within_mem_boundaries (nextAtom), "out of (atom) memory\n")
    r := nextAtom
    nextAtom = nextAtom - CellLength
    return r
}

AllocList :: proc () -> Ptr { 
    fmt.assertf (within_mem_boundaries (nextList), "out of (list) memory\n")
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

initialize :: proc () {
    nextAtom  = FIRSTAtom
    nextList  = FIRSTList
    for i := 0 ; i < len (mem) ; i += 1 {
	mem [i] = 0
    }
    n := intern ("nil")
    Set (0, n)
    Set (0+1, 0)
    intern ("t")
    intern ("car")
    intern ("cdr")
    intern ("atom")
    intern ("cond")
    intern ("cons")
    intern ("quote")
}
