package smalllisp

import "core:fmt"
import "core:strings"

// Eval evaluates the given expression given an environment - a stack of bindings (an Alist) {name:value}
// Eval peels off the low-hanging fruit then punts to Apply() for evaluating anonynmous functions (lambdas).

Eval :: proc (e : Sexpr, env : Alist) {
}

Apply :: proc (f : Sexpr, args: Sexpr, env : Alist) {
}
