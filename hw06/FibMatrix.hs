{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-missing-methods #-}

module FibMatrix where

    data Matrix = Matrix Integer Integer Integer Integer

    instance Num Matrix where
        (*) (Matrix a1 b1 a2 b2) (Matrix x1 y1 x2 y2)= Matrix (a1*x1+b1*x2) (a2*x1+b2*x2) (y1*a1+y2*b1) (y1*a2+y2*b2) 


    fib :: Integer -> Integer
    fib 0 = 1
    fib ix = getFib $ m^ix
        where m = Matrix 1 1 1 0
    
    getFib :: Matrix -> Integer
    getFib (Matrix a _ _ _) = a

