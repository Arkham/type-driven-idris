module WordLength

allLengths : List String -> List Nat
allLengths [] = []
allLengths (word :: words) = length word :: allLengths words

xor : Bool -> Bool -> Bool
xor False y = y
xor True y = not y

mutual
  isEven : Nat -> Bool
  isEven 0 = True
  isEven (S n) = isOdd n

  isOdd : Nat -> Bool
  isOdd 0 = False
  isOdd (S n) = isEven n
