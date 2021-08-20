# Type-driven development with Idris

Idris allows _incomplete_ function definitions to be checked and provides
an expresssive language for describing types.

### Matrix Arithmetic

You can add two matrices if they have the same number of rows and columns.

You can multiply two matrices if they have a particular combination of rows
and columns.

How do we specify that in code?

We could define a `3 x 4` matrix as a type `Matrix 3 4`. Then:

- `add: Matrix x y -> Matrix x y -> Matrix x y`
- `transpose: Matrix x y -> Matrix y x`
- `multiply: Matrix x y -> Matrix y z -> Matrix x z`

### Automated teller machine

States of an ATM machine:

- `Ready` ATM is ready and waiting for user to insert a card
- `CardInserted` ATM is waiting for a user to enter their PIN
- `Session` A validated session is in progress, with the ATm ready to
  dispense cash

Now the ATM supports several operations, each of which is valid only in a
specific state:

- `InsertCard`
- `EjectCard`
- `GetPIN`
- `CheckPIN`
- `Dispense`

```
┌──────────────┐────EjectCard─────▶┌──────────────┐──┐ GetPIN,
│    Ready     │                   │ CardInserted │  │
└──────────────┘────InsertCard────▶└──────────────┘◀─┘ CheckPIN (Incorrect)
        ▲                                  │
        │                                  │
    EjectCard                          CheckPIN
        │                             (Correct)
        │        ┌──────────────┐          │
        └────────│   Session    │◀─────────┘
                 └──────────────┘
                 ▲              │
                 │              │
                 └───Dispense───┘
```

By defining valid transitions in types, you can make sure the program won't
compile if we try to do something weird.

### Concurrent Programming

Multiple processes running at the same time and coordinating with each
other. These processes communicate exchanging messages. The type system can
help us to describe systems that define the correct order of transmission
of those messages.

### Exercises

```
reverse: Vect n elem -> Vect n elem
double: Vect n elem -> Vect (n*2) elem
pop: Vect (1+n) elem -> Vect n elem
get: Bounded n -> Vect n elem -> elem
```

### Pure functional programming

What does functional mean?

- Programs are composed of functions
- Program execution consists of evaluation of functions
- Functions are a first-class language construct

What does pure mean?

- Functions don't have side effects, like modifying global variables,
  throwing exceptions, or performing console input or output.
- For any specific input, a function will always give the same result.
