# User-defined data types

This chapter covers:

- Defining your own data types
- Understanding different forms of data types
- Writing larger interactive programs in the type-driven style

```
Main> :doc List
Prelude.List : Type -> Type
  Generic lists.
  Totality: total
  Constructors:
    Nil : List a
      Empty list
    (::) : a -> List a -> List a
      A non-empty list, consisting of a head element and
      the rest of the list.
```

We’ll classify types into five basic groups, although they’re all defined with the same syntax:

- Enumerated types, defined by giving the possible values directly
- Union types, enumerated types that carry additional data with each value
- Recursive types, union types that are defined in terms of themselves
- Generic types, parameterized over some other types
- Dependent types, computed from some other value

## Enumerated types

```
data Bool = False | True
```

## Union types

```
data Shape = Triangle Double Double
           | Rectangle Double Double
           | Circle Double
```

## Recursive types

```
data Nat = Z | S Nat

data Picture = Primitive Shape
             | Combine Picture Picture
             | Rotate Double Picture
             | Translate Double Double Picture
```

## Generic data types

A generic data type is parameterized over some other type.

Imagine you have a function liket this:

```
biggestTriangle : Picture -> Double
```

But what if there is no triangle in the picture? We might need a new type:

```
data BiggestTriangle = NoTriangle | Size Double

biggestTriangle : Picture -> BiggestTriangle
```

Surely we can think of many cases like this.

```
data Maybe a = Nothing | Just a

data Either a b = Left a | Right b

data Tree elem = Empty
               | Node (Tree elem) elem (Tree elem)
```

## Dependent data types

A dependent data type is computed from some other value. In the case of
`Vect`, the exact type is calculated from the vector's length:

```
Vect: Nat -> Type -> Type
```

Let's say we have a data type to represent vehicles (bikes, cars and
buses), but some operations don't make sense on all values in the type.

```
data PowerSource = Petrol | Pedal
data Vehicle : PowerSource -> Type where
  Bicycle : Vehicle Pedal
  Car : (fuel : Nat) -> Vehicle Petrol
  Bus : (fuel : Nat) -> Vehicle Petrol
```

How about we redefine Vect?

```
data Vect : Nat -> Type -> Type where
  Nil : Vect Z a
  (::) : (x : a) -> (xs : Vect k a) -> Vect (S k) a

%name Vect xs, ys, zs
```

`Vect` is indexed by its length and parameterized by an element type:
- A parameter is unchanged across the entire structure. Every element in
  the vector has the same type.
- An index may change across a structure. Every subvector has a different
  length.

Vectors can be indexed using `Fin` numbers, which have a non-inclusive
upper bound.

```
index : Fin n -> Vect n a -> a
```

# Type-driven implementation of an interactive data store

We'll support storing data as Strings in memory, accessed by a numeric
identifier. It will support:
- `add : String -> Id`, stores value and returns id
- `get : Id -> Maybe String`, fetches string identified by id
- `quit` exits the program

## Summary

- Data types are defined in terms of type constructors and data constructors
- Enumerated types are defined by listing the data constructors
- Union types are defined by listing the data constructors, each of which
  may carry additional information.
- Generic types are parameterized over some other type.
- Dependent types can be indexed over any other value. Using them, you can
  classify a larger family of types into smaller subgroups.
- They allow safety checks to be guaranteed at compile time, such as
  guaranteeing that all vector accesses are within bounds.
- You can write larger programs in type-driven style, creating new data
  types where appropriate.
- Interactive programs that involve state can be written with the
  `replWith` function.
