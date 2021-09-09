# Core Idris

- Type: write a type for a function
- Define: create a definition for the function (with holes)
- Refine: complete the definition by filling in holes and modifying the
  type as your understanding of the problem develops

# Interactive development with types

- `\a` adds skeleton definition
- `\t` checks type
- `\c` case split

You can also use `:total` to check a function totality.

How does case split work?

```
Main> :doc List
Prelude.List : Type -> Type
  Generic lists.
  Totality: total
  Constructors:
    Nil : List a
      Empty list
    (::) : a -> List a -> List a
      A non-empty list, consisting of a head element and the rest of the list.

Main> :doc Nat
Prelude.Nat : Type
  Natural numbers: unbounded, unsigned integers which can be pattern matched.
  Totality: total
  Constructors:
    Z : Nat
      Zero.
    S : Nat -> Nat
      Successor.
```

There is overloading of many symbols:

```
Vectors> :t the (List _) ["Hi"]
the (List String) [fromString "Hi"] : List String

Vectors> :t the (Vect _ _) ["Hi"]
the (Vect 1 String) [fromString "Hi"] : Vect 1 String
```

Very interesting bit. This is well-typed:

```
allLengths : List String -> List Nat
allLengths xs = []
```

But this is NOT

```
allLengths : Vect n String -> Vect n Nat
allLengths xs = []
```

and it will yield

```
Error: allLengths is not covering.

Vectors:14:1--14:45
 13 |
 14 | allLengths : Vect len String -> Vect len Nat
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Missing cases:
    allLengths (_ :: _)
```
