package smalllisp

MemSize :: 17
MemMiddle :: MemSize / 2
MemPtr :: i16
Ptr :: MemPtr
nr :: '⊥' // null rune
EOFrune :: nr
lisp_nil :: MemMiddle // > nil == list cells, < nil == atoms
offset :: MemMiddle

ENDcharacter : rune // == 0
ENDcharacterAsByte : byte = 0
CARsize :: 1
CDRsize :: 1
CellLength :: CARsize + CDRsize
CDRoffset :: CARsize

FIRSTAtom :: -2
FIRSTList :: 1
