package smalllisp
import "core:fmt"
import "core:strings"

match_string_from_beginning :: proc (s : string, atom_ptr : Ptr) -> bool {
    fmt.assertf (atom_ptr <= lisp_nil, "FATAL internal error in match_string_from_beginning (nil) %v", atom_ptr)
    fmt.assertf (len (s) > 0, "FATAL internal error in match_string_from_beginning (len s) %v", atom_ptr)
    return match_string (s, atom_ptr)
}

match_string :: proc (s : string, atom_ptr : Ptr) -> bool {
    if atom_ptr == lisp_nil {
	if 0 == len (s) { // end of atom && end of string
	    return true
	} else {                // end of atom but not end of string
	    return false 
	}
    } else {
	if s [0] == GetByte (atom_ptr) {
	    return match_string (s [1:], Cdr (atom_ptr))
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
    fmt.println ("install_new_atom_helper", b)
    if 0 == len (b) {
	return lisp_nil
    } else {
	a := AllocAtom ()
	SetByte (a, b [0])
	Set (a+CDRoffset, install_new_atom_helper (b [1:]))
	return a
    }
}

intern :: proc (s : string) -> Ptr {
    // scan all Atoms
    // if s is aready an Atom, return a Ptr to the first atom cell of that Atom
    // if s is not already an Atom, make an Atom with the given name and return a Ptr to the first cell

    // search for existing
    head : Ptr = FIRSTAtom
    for in_atom_space (head) {
	if match_string_from_beginning (s, head) {
	    return head
	}
	head = find_next_atom (head)
    }

    // install new
    a := install_new_atom (s)
    return a
}
		
