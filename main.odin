package smalllisp

// testing

import "core:fmt"

main :: proc () {
    open ()
    ReadAtom ('X')
    fmt.println (mem)
    close ()
}
