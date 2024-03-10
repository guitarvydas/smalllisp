package smalllisp

import "core:fmt"
import "core:strings"
import uni "core:unicode/utf8"

////////

input_index : int

open :: proc () {
    input_index = 0
}

close :: proc () {
}

getr :: proc () -> rune {
    if input_index >= len (input) {
	return EOF
    } else {
	r := uni.rune_at_pos (input, input_index)
	input_index += uni.rune_size (r)
	return r
    }
}

put_back :: proc (r : rune) {
    if r != EOF {
	input_index -= 1
	fmt.assertf (r == uni.rune_at_pos (input, input_index), "FATAL in put_back")
    }
}

///


is_whitespace :: proc (c : rune) -> bool {
    if c == ' ' || c == '\n' || c == '\t' {
	return true
    } else {
	return false
    }
}

is_terminator :: proc (c : rune) -> bool {
    if is_whitespace (c) {
	return true
    } else if c == '(' || c == ')' || c == EOF {
	return true
    } else {
	return false
    }
}

is_EOF :: proc (c : rune) -> bool {
    return c == EOF
}

get_non_whitespace :: proc () -> rune {
    c := getr ()
    for ; is_whitespace (c) || is_EOF (c); c = getr () {
    }
    return c
}

Read :: proc () -> Ptr {
    c := get_non_whitespace ()
    fmt.assertf (c != EOF, "FATAL error: EOF in Read")
    if c == '(' {
	return ReadList (c);
    } else {
	return ReadAtom (c);
    }
}

ReadAtom :: proc (parsed_c : rune) -> Ptr {
    save_rune :: proc (r : rune, buffer : ^strings.Builder) {
	strings.write_rune (buffer, r)
    }
    buffer := strings.builder_make ()
    save_rune (parsed_c, &buffer)
    {
	c := rune{}
	for c = getr () ; !is_terminator (c) ; c = getr (){
	    save_rune (c, &buffer)
	}
	put_back (c)
    }
    p := intern (strings.to_string (buffer))
    return p
}

ReadList :: proc (c : rune) -> Ptr {
    // already read open paren (contained in 'c')
    return ReadListInnards ()
}

ReadListInnards :: proc () -> Ptr {
    r := get_non_whitespace ()
    fmt.assertf (r != EOF, "FATAL error: unterminated list, EOF encountered before matching ')'")
    if r == ')' {
	return lisp_nil
    } else {
	put_back (r)
	first := Read ()
	rest := ReadListInnards ()
	return Cons (first, rest)
    }
}

format :: proc (p : Ptr) -> string {
    if is_Nil (p) {
	return "()"
    } else if is_Atom (p) {
	return atom_as_String (p)
    } else {
	b := strings.builder_make ()
	strings.write_string (&b, "(")
	strings.write_string (&b, format (Car (p)))
	lformat (&b, Cdr (p))
	strings.write_string (&b, ")")
	return strings.to_string (b)
    }
}

lformat :: proc (b : ^strings.Builder, p : Ptr) {
    if is_Nil (p) {
    } else if is_Atom (p) {
	strings.write_string (b, " . ")
	strings.write_string (b, format (p))
    } else {
	strings.write_string (b, " ")
	strings.write_string (b, format (Car (p)))
	lformat (b, Cdr (p))
    }
}



// uf ==> unfriendly
ufFormat :: proc (p : Ptr) -> string {
    if is_Nil (p) {
	return "nil"
    } else if is_Atom (p) {
	return atom_as_String (p)
    } else {
	left := ufFormat (Car (p))
	right := ufFormat (Cdr (p))
	return fmt.aprintf ("(%v . %v)", left, right)
    }	
}

atom_as_String :: proc (p : Ptr) -> string {
    b := strings.builder_make ()
    atom_as_Builder (p, &b)
    return strings.to_string (b)
}

atom_as_Builder :: proc (p : Ptr, builderp : ^strings.Builder) -> ^strings.Builder {
    if !is_Nil (p) {
	c := GetByte (p)
	if c == EOF {
	    strings.write_byte (builderp, c)
	} else {
	    strings.write_byte (builderp, c)
	    atom_as_Builder (Cdr (p), builderp)
	}
    }
    return builderp
}
