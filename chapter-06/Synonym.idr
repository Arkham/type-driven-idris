module Synonym

import Data.Vect

Position : Type
Position = (Double, Double)

Polygon : Nat -> Type
Polygon n = Vect n Position

tri : Polygon 3
tri = ?foo
