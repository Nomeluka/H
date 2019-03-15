### Some Details
Monoid & Semigroup hw07 Srabble.hs
<> and mempty are defined in Semigroup and Monoid respectively in new GHC

Monad & Applicative hw07 Editor.hs
Monad need to be an instance of Applicative in new GHC

FlexibleInstances & InstanceSigs InstanceSigs & hw07 JoinList.hs 
when declare a instance with type signature, a prefix is needed

parametric type class hw05 Calc.hs
when a function with parametric type class signature, GHC would not compile up 
until we bind it to a specific instance of that type class 

### Some Tricks
tilde pattern in hw6 Stream.hs
tilde pattern is a non-strict lazy evaluation which is lazier 

foldr and foldl hw04 Problem3.hs
they can transform from each other, this is an excellent trainning in curry functions

### A brief haskell knowledge list
 
pattern matching
     |
 Recursion
     | 
Curry Functions : Prelude functions like map, filter, fold...
     |
Polymorphism & Type Class 
     |
Type Class Monoid
	 |
Type Class Functor : Functor, Applicative, Alternative...
     |
Functor Monad: IO, Monad tansform...