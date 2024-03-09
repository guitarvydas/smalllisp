package smalllisp

// testing

import "core:fmt"

input0 := ""
input1 := "1"
input2 := "12"
input3 := "123"

input := input0

main :: proc () {
    open ()
    ReadAtom ('*')
    fmt.printf ("%x %x %x %x %x %x\n", Get (1), Get (2), Get (3), Get (4), Get (5), Get (6))
    fmt.printf ("%x\n", Get (0))
    fmt.printf ("%x %x %x %x %x %x\n", Get (-2), Get (-1), Get (-4), Get (-3), Get (-6), Get (-5))
    close ()
}
