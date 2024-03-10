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
    nextAtom = nextAtom + CellLength
    return r
}

AllocList :: proc () -> Ptr { 
    fmt.assertf (within_mem_boundaries (nextList), "out of (list) memory\n")
    r := nextList
    nextList = nextList - CellLength
    return r
}

Cons :: proc (left : Ptr, right : Ptr) -> Ptr {
    p := AllocList ()
    Set (p, left)
    Set (p + 1, right)
    return p
}

initialize :: proc () {
    for i := 0 ; i < len (mem) ; i += 1 {
	mem [i] = 0
    }
    nextAtom  = FIRSTAtom
    nextList  = FIRSTList
    install_new_atom ("nil")	// 0
    install_new_atom ("t")	// 6
    install_new_atom ("eq")	// 8
    install_new_atom ("car")	// 12
    install_new_atom ("cdr")	// 18
    install_new_atom ("atom")	// 24
    install_new_atom ("cond")	// 32
    install_new_atom ("cons")	// 40
    install_new_atom ("quote")	// 48
}
