# Programming with first-class types

- Programming with type-level functions
- Writing functions with varying number of arguments
- Using type-level functions to calculate the structure of data
- Refining larger interactive programs

We'll see how we can write a type-safe version of `printf`.

## Type-level functions: calculating types

Types and expressions are part of the same language. Remember:

```idris
append : Vect n elem -> Vect m elem -> Vect (n + m) elem
```

### Type synonyms: giving good names to complex types

```idris
tri : Vect 3 (Double, Double)
tri = [(0.0, 0.0), (3.0, 0.0), (0.0, 4.0)]

Position : Type
Position = (Double, Double)

tri : Vect 3 Position
tri = [(0.0, 0.0), (3.0, 0.0), (0.0, 4.0)]
```

But they can also take arguments :)

```idris
Polygon : Nat -> Type
Polygon n = Vect n Position

tri : Polygon 3
tri = [(0.0, 0.0), (3.0, 0.0), (0.0, 4.0)]
```

### Type-level functions with pattern matching

Type-level functions are just ordinary functions that happen to return a `Type`.

```idris
StringOrInt : Bool -> Type
StringOrInt False = String
StringOrInt True = Int

getStringOrInt : (isInt : Bool) -> StringOrInt isInt
getStringOrInt False = "Ninety four"
getStringOrInt True = 94

valToString : (isInt : Bool) -> StringOrInt isInt -> String
valToString False x = trim x
valToString True x = cast x
```

### Using case expressions in types

```idris
valToString : (isInt : Bool) -> (case isInt of
                                     False => String
                                     True => Int) -> String
valToString False x = trim x
valToString True x = cast x
```

Type-level functions exist at compile time only. There is no runtime
representation of `Type`.

## Defining functions with variable number of arguments

Let's see some examples

### An addition function

```idris
--    num of additional args
--    |
--    | initial value
--    | |
adder 0 10 => 10
adder 1 10 15 = 25
adder 2 10 15 20 = 45
```

### A type-safe printf function

```idris
printf "Hello!" : String
printf "Answer: %d" : Int -> String
printf "%s number %d" : String -> Int -> String
```

Instead of using a format string we can use a type:

```idris
data Format = Number Format
            | Str Format
            | Lit String Format
            | End
```

so that we can represent something like `%s number %d` as:

```idris
Str (Lit " number " (Number End))
```

## Enhancing the interactive data store with schemas

We'll change our data store to be able to store data associated with a
schema.

```
Command: schema String String Int
OK
Command: add "Rain Dogs" "Tom Waits" 1985
ID 0
Command: add "Fog on the Tyne" "Lindisfarne" 1971
ID 1
Command: get 1
"Fog on the Tyne", "Lindisfarne", 1971
Command: quit
```

We'll take this approach:
- Refine the representation of `DataStore` to include schema descriptions
- Correct any errors and add type holes for more complex errors
- Fill in the holes to complete the implementation and add more features

## Refining the DataStore type

Coding time!
