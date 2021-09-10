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


