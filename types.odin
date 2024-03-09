package smalllisp

MemSize :: 65
MemMiddle :: MemSize / 2
MemPtr :: i16
Ptr :: MemPtr
nr :: '⊥' // null rune
EOFrune :: nr
lisp_nil :: 0 // > nil --> list cells, < nil --> atoms
offset :: MemMiddle

CARsize :: 1
CDRsize :: 1
CellLength :: CARsize + CDRsize
CDRoffset :: CARsize

FIRSTAtom :: -2
FIRSTList :: 1

// atom: car == 1 byte (character), cdr == Ptr
// list: car == Ptr, cdr == Ptr
// where Ptr might be 0, meaning nil

in_atom_space :: proc (p : Ptr) -> bool {
    return (p < 0) && ((p + offset) >= 0)
}

