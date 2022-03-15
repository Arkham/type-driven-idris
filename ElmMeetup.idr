module ElmMeetup

import Data.List as List
import Data.Vect as Vect

theBeatles : List String
theBeatles = ["John", "Paul", "George", "Ringo"]

-- ElmMeetup> :t Vect.index
-- Vect.index : Fin len -> Vect len elem -> elem

-- FZ : Fin (S k)
-- FS : Fin k -> Fin (S k)

-- data Nat =
--   Z
--   | S Nat
