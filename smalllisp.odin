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


nextAtom : Ptr = -1
nextList : Ptr = 1

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
    fmt.assertf (nextAtom > 0, "out of (atom) memory\n")
    r := nextAtom
    nextAtom = nextAtom - CellLength
    return r
}

AllocList :: proc () -> Ptr { 
    fmt.assertf (nextList < len (mem) - lisp_nil, "out of (list) memory\n")
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

match_string_from_beginning :: proc (s : string, atom_ptr : Ptr) -> bool {
    fmt.assertf (atom_ptr < lisp_nil, "FATAL internal error in match_string_from_beginning (nil)")
    fmt.assertf (len (s) > 0, "FATAL internal error in match_string_from_beginning (len s)")
    s_as_bytes := transmute ([]byte) s
    return match_string (s_as_bytes, atom_ptr)
}

match_string :: proc (s_bytes : []byte, atom_ptr : Ptr) -> bool {
    if atom_ptr == lisp_nil {
	if 0 == len (s_bytes) { // end of atom && end of string
	    return true
	} else {                // end of atom but not end of string
	    return false 
	}
    } else {
	first_byte_in_atom := GetFirstByte (atom_ptr)
	second_byte_in_atom := GetSecondByte (atom_ptr)
	next := Cdr (atom_ptr)

	if s_bytes [0] == first_byte_in_atom {
	    if 1 == len (s_bytes) {
		if cast (byte) ENDcharacter == second_byte_in_atom {
		    return match_string (s_bytes [2:], next)
		} else {
		    return false
		}
	    } else if s_bytes [1] == second_byte_in_atom {
		return match_string (s_bytes [2:], next)
	    } else {
		return false
	    }
	} else {
	    return false
	}
    }
}

find_next_atom :: proc (p : Ptr) -> Ptr {
    next := Cdr (p)
    for lisp_nil != next {
	next = Cdr (next)
    }
    return next
}

in_atom_space :: proc (p : Ptr) -> bool {
    return p > nextAtom
}

install_new_atom :: proc (s : string) -> Ptr {
    fmt.assertf (len (s) > 0, "FATAL internal error: in install_new_atom")
    return install_new_atom_helper (s[:])
}

install_new_atom_helper :: proc (b : string) -> Ptr {
    if 0 == len (b) {
	return lisp_nil
    } else {
	a := AllocAtom ()
	first_byte := b [0]
	second_byte := cast (byte) ENDcharacter
	if 1 < len (b) {
	    second_byte = b [1]
	}
	d := install_new_atom_helper (b [2:])
	car := transmute (Ptr) ([2]byte{first_byte, second_byte})
	Set (a, car)
	Set (a+CDRoffset, d)
	return a
    }
}
	

intern :: proc (s : string) -> Ptr {
    // scan all Atoms
    // if s is aready an Atom, return a Ptr to the first atom cell of that Atom
    // if s is not already an Atom, make an Atom with the given name and return a Ptr to the first cell

    // search for existing
    head : Ptr = -1
    for in_atom_space (head) {
	if match_string_from_beginning (s, head) {
	    return head
	}
	head = find_next_atom (head)
    }

    // install new
    return install_new_atom (s)
}
