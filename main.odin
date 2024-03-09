package smalllisp

// testing

import "core:fmt"

input1 := "1"
input2 := "12"
input3 := "123"
input4 := "1234"
input5 := "5 6"

input6 := "(A)"
input7 := "(A B)"
input8 := "(C (D))"
input9 := "(E (F G) H)"

input := input6

dump_mem :: proc () {
    fmt.printf ("  [%x|%4X] [%x|%4X] [%x|%4X] [%x|%4X] [%x|%4X]\n",
		Get (1), Get (2),
		Get (3), Get (4),
		Get (5), Get (6),
		Get (7), Get (8),
		Get (9), Get (10)
	       )
    fmt.printf ("  %x\n", Get (0))
    fmt.printf ("  [%x|%4X] [%x|%4X] [%x|%4X] [%x|%4X] [%x|%4X]\n",
		Get (-2), Get (-1),
		Get (-4), Get (-3),
		Get (-6), Get (-5),
		Get (-8), Get (-7),
		Get (-10), Get (-9)
	       )
}

reset_mem :: proc () {
    nextAtom  = FIRSTAtom
    nextList  = FIRSTList
    for i := 0 ; i < len (mem) ; i += 1 {
	mem [i] = 0
    }
}

test :: proc (inp : string) {
    input = inp
    reset_mem ()
    fmt.printf ("\n\n\n*** %v\n", input)
    open ()
    fmt.println ("test", Read())
    dump_mem ()
    close ()
}

test_2 :: proc (inp : string) {
    input = inp
    reset_mem ()
    fmt.printf ("\n\n\n*** test_2 *** %v\n", input)
    open ()
    fmt.println ("test_2", Read())
    dump_mem ()
    fmt.println ("test_2", Read())
    dump_mem ()
    close ()
}

main :: proc () {
    /* test (input1) */
    /* test (input2) */
    /* test (input3) */
    /* test (input4) */
    /* test_2 (input5) */
    /* test (input6) */
    /* test (input7) */
    /* test (input8) */
    test (input9)
}
