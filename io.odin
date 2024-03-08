package smalllisp

import "core:fmt"
import "core:strings"
import uni "core:unicode/utf8"

////////

input := "a"
input_index : int

open :: proc () {
    input_index = 0
}

close :: proc () {
}

getr :: proc () -> rune {
    r := uni.rune_at_pos (input, input_index)
    input_index += 1
    return r
}

put_back :: proc (r : rune) {
    input_index -= 1
    fmt.assertf (r == uni.rune_at_pos (input, input_index), "FATAL in put_back")
}

///

Read :: proc () -> Ptr {
    c := getr ()
    for is_whitespace (c) {
	c = getr ()
    }
    if c == '(' {
	return ReadList (c);
    } else {
	return ReadAtom (c);
    }
}

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
    } else if c == '(' || c == ')' || c == EOFrune {
	return true
    } else {
	return false
    }
}

    
ReadAtom :: proc (parsed_c : rune) -> Ptr {
    save_rune :: proc (r : rune, buffer : ^strings.Builder) {
	strings.write_rune (buffer, r)
    }
    buffer := strings.builder_make ()
    save_rune (parsed_c, &buffer)
    c := rune{}
    for c = getr () ; !is_terminator (c) ; c = getr (){
	save_rune (c, &buffer)
    }
    put_back (c)
    p := intern (strings.to_string (buffer))
    return p
}

ReadList :: proc (c : rune) -> Ptr {
    // already read open paren (contained in 'c')
    return ReadListInnards ()
}

ReadListInnards :: proc () -> Ptr {
    r := getr ()
    if r == ')' {
	return lisp_nil
    } else {
	put_back (r)
	first := Read ()
	rest := ReadListInnards ()
	return Cons (first, rest)
    }
}

		
// testing

main :: proc () {
    open ()
    fmt.println (getr ())
}
