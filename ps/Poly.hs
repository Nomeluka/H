module L where

data A = Cons
  deriving (Show)
instance Num A where
    fromInteger a = Cons
 
foo :: Num a => a -> a
foo _ = 1

