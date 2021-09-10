module Main

import System.REPL

sumInputs : Integer -> String -> Maybe (String, Integer)
sumInputs tot y =
  let newNumber = cast y
  in case newNumber < 0 of
                     False =>
                             let newTot = tot + newNumber
                             in Just ("Subtotal: " ++ show newTot ++ "\n", newTot)
                     True => Nothing

main : IO ()
main = replWith 0 "Value: " sumInputs
