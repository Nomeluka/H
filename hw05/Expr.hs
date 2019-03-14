module Expr where

class (Show a) => Expr a where
    lit :: Integer -> a
    add :: a -> a -> a
    mul :: a -> a -> a