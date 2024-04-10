package smalllisp

import "core:fmt"
import "core:strings"

// Eval evaluates the given expression given an environment - a stack of bindings (an Alist) {name:value}
// Eval peels off the low-hanging fruit then punts to Apply() for evaluating anonynmous functions (lambdas).

Eval :: proc (e : Sexpr, env : Alist) -> MemPtr {
    /* if is_atom (e) { */
    /* 	v := lookup (e, env) */
    /* 	return v */
    /* } else { */
    /* 	first_item := Car (e) */
    /* 	if !is_atom (first_item) { */
    /* 	    // first item is a list, hence, this list must be an anonymous funtion (a LAMBDA) */
    /* 	    remainder := Cdr (e) */
    /* 	    return Apply (first_item, remainder, env) */
    /* 	} else { */
    /* 	    switch (atom_name (first_item)) { */
    /* 	    case kNil: // "nil" */
    /* 	    case kT: // "t" */
    /* 	    case kEQ: // "eq" */
    /* 	    case kCar: // "car" */
    /* 	    case kCdr: // "cdr" */
    /* 	    case kAtom:  // "atom" */
    /* 	    case kCond: // "cond" */
    /* 	    case kCons: // "cons" */
    /* 	    case kQuote: // "quote" */
    /* 		case: // else error */
    /* } */
    return 0
}

Apply :: proc (f : Sexpr, args: Sexpr, env : Alist) {
}

