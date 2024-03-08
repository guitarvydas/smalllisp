package smalllisp

MemSize :: 1001
MemMiddle :: MemSize / 2
MemPtr :: i16
Ptr :: MemPtr
nr :: '⊥' // null rune
EOFrune :: nr
lisp_nil :: MemMiddle // > nil == list cells, < nil == atoms
offset :: MemMiddle

ENDcharacter : rune // == 0
CellLength :: 2 * size_of (Ptr)
CDRoffset :: size_of (Ptr)
