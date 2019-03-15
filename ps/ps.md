### Some Details
Monoid & Semigroup hw07 Srabble.hs  
<> and mempty are defined in Semigroup and Monoid respectively in new GHC

{-  
instance Semigroup 	...	where  
instane  Monoid 	... where  
-}

Monad & Applicative hw07 Editor.hs  
Monad need to be an instance of Applicative in new GHC  
-- instance Applicative ... where  

FlexibleInstances & InstanceSigs InstanceSigs & hw07 JoinList.hs  
when declare a type class instance with type signature parameter, a prefix is needed  
-- intance MyTypeClass (MyType Integer) where  

parametric type class hw05 Calc.hs  
when a function with parametric type class signature, GHC would not compile up until we bind it to a specific instance of that type class  
{-  
foo :: MyTypeClass a => a   
foo = ...  
testFoo = foo :: MyType  
-}

polymorphism  
a function's parameters and output must be matched to the type signature strictly  
when the type signature is polymorphism, the inputs and output would be polymorphism as well  
a special example

{- Poly.hs  
data A = Cons  
  deriving (Show)  
instance Num A where  
    fromInteger a = Cons  
foo :: Num a => a -> a  
foo a = 1 -- when calling foo Cons, the right 1 is infered as an A type, thus if we do not implement fromInteger function, ghc would have an exception although compile ok   
-}

### Some Tricks
tilde pattern hw6 Stream.hs  
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