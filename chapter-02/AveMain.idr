module AveMain

import Average
import System.REPL

showAverage : String -> String
showAverage str = "The average words length is: " ++
                  show (average str) ++ "\n"

main : IO ()
main = repl "Enter a string: " showAverage
