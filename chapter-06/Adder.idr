module Adder

AdderType : (numArgs : Nat) -> Type
AdderType Z = Int
AdderType (S k) = (next : Int) -> AdderType k

adder : (numArgs : Nat) -> (acc : Int) -> AdderType numArgs
adder Z acc = acc
adder (S k) acc = \next => adder k (acc + next)

-- Adder> adder 0 10
-- 10
-- Adder> adder 1 10 15
-- 25
-- Adder> adder 2 10 15 20
-- 45

NAdderType : (numArgs : Nat) -> Type -> Type
NAdderType Z numType = numType
NAdderType (S k) numType = (next: numType) -> NAdderType k numType

nadder : Num numType => (numArgs : Nat) -> (acc : numType) -> NAdderType numArgs numType
nadder Z acc = acc
nadder (S k) acc = \next => nadder k (acc + next)

-- Adder> nadder 0 10.0
-- 10.0
-- Adder> nadder 1 10.0 5.0
-- 15.0
-- Adder> nadder 2 10.0 5.0 2.5
-- 17.5
