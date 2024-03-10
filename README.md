# small lisp written in Odin 
- based on McCarthy's 1.5 and Tunney's Sector Lisp
- notably, uses Tunney's functional GC (doesn't need a heap nor stop-the-world behaviour)
- Odin is a GC-less language, this implementation does not need a heap-based GC (i.e. no RAM-style mutation)

# Status
- Read and format implemented (i.e. the hard part)
- still need to implement Eval() and Apply() and TGC()

# TODO:

