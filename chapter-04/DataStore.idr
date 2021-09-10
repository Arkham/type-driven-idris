module Main

import Data.Vect
import System.REPL
import Data.String

data DataStore : Type where
  MkData : (size : Nat) -> (items: Vect size String) -> DataStore

size : DataStore -> Nat
size (MkData size' items') = size'

items : (store : DataStore) -> Vect (size store) String
items (MkData size' items') = items'

addToStore : DataStore -> String -> DataStore
addToStore (MkData 0 []) y = MkData 1 [y]
addToStore (MkData _ items) y = MkData _ (items ++ [y])

data Command = Add String
             | Get Integer
             | Search String
             | Size
             | Quit

parseCommand : (cmd : String) -> (args : String) -> Maybe Command
parseCommand "quit" _ = Just Quit
parseCommand "size" _ = Just Size
parseCommand "add" rest = Just (Add rest)
parseCommand "get" rest =
  case all isDigit (unpack rest) of
       False => Nothing
       True => Just (Get (cast rest))
parseCommand "search" val = Just (Search val)
parseCommand _ _ = Nothing

parse : String -> Maybe Command
parse input = case span (/= ' ') input of
                          (cmd, args) => parseCommand cmd (ltrim args)

getEntry : Integer -> DataStore -> Maybe String
getEntry idx store =
  let items' = items store in
      case integerToFin idx (size store) of
           Nothing => Nothing
           (Just x) => Just (index x items')

searchVal : String -> DataStore -> List (Integer, String)
searchVal val store =
  let items' = items store
      matches = findIndices (isInfixOf val) items'
  in map (\idx => (cast idx, Vect.index idx items')) matches

formatMatch : (Integer, String) -> String
formatMatch (int, str) = show int ++ ": " ++ str

processInput : DataStore -> String -> Maybe (String, DataStore)
processInput store input =
  case parse input of
    Nothing => Just ("Invalid command\n", store)
    (Just (Add val)) =>
      Just ("ID " ++ show (size store) ++ "\n", addToStore store val)
    (Just (Get idx)) => case getEntry idx store of
                           Nothing => Just ("Out of range\n", store)
                           (Just y) => Just (y ++ "\n", store)
    (Just (Search val)) => case searchVal val store of
                                [] => Just ("No matches\n", store)
                                matches => Just ((unlines (map formatMatch matches)) ++ "\n", store)

    (Just Size) => Just ("Size: " ++ show (size store) ++ "\n", store)
    (Just Quit) => Nothing


main : IO ()
main = replWith (MkData _ []) "Command: " processInput

