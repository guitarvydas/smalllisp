package smalllisp

// testing

import "core:fmt"

input0 := ""
input1 := "1"
input2 := "12"
input3 := "123"
input4 := "1234"
input5 := "5 6"
input7 := " 7 "

input := input5

dump_mem :: proc () {
    fmt.printf ("%x %x %x %x %x %x\n", Get (1), Get (2), Get (3), Get (4), Get (5), Get (6))
    fmt.printf ("%x\n", Get (0))
    fmt.printf ("%x %x %x %x %x %x\n", Get (-2), Get (-1), Get (-4), Get (-3), Get (-6), Get (-5))
}

test5 :: proc () {
    open ()
    Read ()
    dump_mem ()
    Read ()
    dump_mem ()
    close ()
}

test :: proc (inp : string) {
    input = inp
    nextAtom  = FIRSTAtom
    nextList  = FIRSTList
    fmt.printf ("\n*** %v\n", input)
    open ()
    Read()
    dump_mem ()
    close ()
}

test_2 :: proc (inp : string) {
    input = inp
    nextAtom  = FIRSTAtom
    nextList  = FIRSTList
    fmt.printf ("\n*** test_2 *** %v\n", input)
    open ()
    Read()
    dump_mem ()
    Read()
    dump_mem ()
    close ()
}

main :: proc () {
    test (input0)
    test (input1)
    test (input2)
    test (input3)
    test (input4)
    test_2 (input5)
}
