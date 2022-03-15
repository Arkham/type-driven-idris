module Matrix

import Data.Vect as Vect

aMatrix : Vect 2 (Vect 3 Int)
aMatrix =
  [
    [ 1, 2, 3 ],
    [ 4, 5, 6 ]
  ]

result : Vect 3 (Vect 2 Int)
result =
  [
    [ 1, 4 ],
    [ 2, 5 ],
    [ 3, 6 ]
  ]

createEmpties : ( n : Nat ) -> Vect n (Vect 0 Int)
createEmpties n = Vect.replicate n []

transposeHelper : Vect n Int -> Vect n (Vect len Int) -> Vect n (Vect (S len) Int)
transposeHelper [] [] = []
transposeHelper (x :: xs) (y :: ys) = (x :: y) :: transposeHelper xs ys

transposeMatrix : { n : _ } -> Vect m (Vect n Int) -> Vect n (Vect m Int)
transposeMatrix {n} [] = createEmpties n
transposeMatrix (x :: xs) = let xsTrans = transposeMatrix xs in
                                transposeHelper x xsTrans
