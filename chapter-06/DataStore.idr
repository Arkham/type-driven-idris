module Main

import Data.Vect
import System.REPL
import Data.String
import Data.List

infixr 5 .+.

data Schema = SString
            | SInt
            | SChar
            | (.+.) Schema Schema

SchemaType : Schema -> Type
SchemaType SString = String
SchemaType SInt = Int
SchemaType SChar = Char
SchemaType (x .+. y) = (SchemaType x, SchemaType y)

record DataStore where
  constructor MkData
  schema: Schema
  size : Nat
  items : Vect size (SchemaType schema)

addToStore : (store : DataStore) -> SchemaType (schema store) -> DataStore
addToStore (MkData s 0 []) y = MkData s 1 [y]
addToStore (MkData s _ items) y = MkData s _ (items ++ [y])

data Command : Schema -> Type where
  SetSchema : (newSchema : Schema) -> Command s
  Add : SchemaType s -> Command s
  Get : Integer -> Command s
  GetAll : Command s
  Quit : Command s

parsePrefix : (s: Schema) -> String -> Maybe (SchemaType s, String)
parsePrefix SString x = getQuoted (unpack x)
  where
    getQuoted : List Char -> Maybe (String, String)
    getQuoted ('"' :: xs) =
      case span (/= '"') xs of
           (quoted, '"' :: rest) => Just (pack quoted, ltrim (pack rest))
           _ => Nothing
    getQuoted _ = Nothing
parsePrefix SInt x =
  case span isDigit x of
       ("", rest) => Nothing
       (num, rest) => Just (cast num, ltrim rest)
parsePrefix SChar x =
  case unpack x of
       ('\'' :: char :: '\'' :: rest) => Just (char, ltrim (pack rest))
       _ => Nothing
parsePrefix (y .+. z) x = do
  (leftVal, x') <- parsePrefix y x
  (rightVal, x'') <- parsePrefix z x'
  Just ((leftVal, rightVal), x'')

parseBySchema : (s : Schema) -> String -> Maybe (SchemaType s)
parseBySchema s input =
  case parsePrefix s input of
       Just (res, "") => Just res
       _ => Nothing

parseSchema : List String -> Maybe Schema
parseSchema ("String" :: xs) =
  case xs of
       [] => Just SString
       _ => do otherSchema <- parseSchema xs
               Just (SString .+. otherSchema)
parseSchema ("Int" :: xs) =
  case xs of
       [] => Just SInt
       _ => do otherSchema <- parseSchema xs
               Just (SInt .+. otherSchema)
parseSchema ("Char" :: xs) =
  case xs of
       [] => Just SChar
       _ => do otherSchema <- parseSchema xs
               Just (SChar .+. otherSchema)
parseSchema _ = Nothing

parseCommand : (s : Schema) -> (cmd : String) -> (args : String) -> Maybe (Command s)
parseCommand s "quit" "" = Just Quit
parseCommand s "add" rest = do
  val <- parseBySchema s rest
  Just (Add val)
parseCommand s "get" "" = Just GetAll
parseCommand s "get" rest =
  case all isDigit (unpack rest) of
       False => Nothing
       True => Just (Get (cast rest))
parseCommand s "schema" rest = do
  newSchema <- parseSchema (words rest)
  Just (SetSchema newSchema)
parseCommand _ _ _ = Nothing

parse : (s : Schema) -> (input : String) -> Maybe (Command  s)
parse s input =
  case span (/= ' ') input of
       (cmd, args) => parseCommand s cmd (ltrim args)

getEntry : Integer -> (store : DataStore) -> Maybe (SchemaType (schema store))
getEntry idx store = do
  x <- integerToFin idx (size store)
  Just (index x (items store))

formatMatch : (Integer, String) -> String
formatMatch (int, str) = show int ++ ": " ++ str

display : {s: _ } -> SchemaType s -> String
display {s = SString} item = show item
display {s = SInt} item = show item
display {s = SChar} item = show item
display {s = (x .+. y)} (item1, item2) = display item1 ++ ", " ++ display item2

setSchema : (store : DataStore) -> Schema -> Maybe DataStore
setSchema store s =
  case size store of
       Z => Just (MkData s _ [])
       S k => Nothing

summary : (store : DataStore) -> String
summary store =
  "Hi mom"

processInput : DataStore -> String -> Maybe (String, DataStore)
processInput store input =
  case parse (schema store) input of
    Nothing => Just ("Invalid command\n", store)
    (Just (Add val)) =>
      Just ("ID " ++ show (size store) ++ "\n", addToStore store val)
    (Just (Get idx)) => case getEntry idx store of
                           Nothing => Just ("Out of range\n", store)
                           (Just y) => Just (display y ++ "\n", store)
    (Just (SetSchema s)) => case setSchema store s of
                                 Nothing => Just ("Can't update schema\n", store)
                                 Just store' => Just ("OK\n", store')
    (Just Quit) => Nothing
    (Just GetAll) => Just (summary store, store)
    _ => Nothing


main : IO ()
main = replWith (MkData SString _ []) "Command: " processInput
