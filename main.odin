package smalllisp

// testing

import "core:fmt"

main :: proc () {
    open ()
    ReadAtom ('X')
    ReadAtom ('Y')
    ReadAtom ('Z')
    fmt.println (mem)
    close ()
}
