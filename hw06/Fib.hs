module Fib where

fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib x = fib (x-1) + fib (x-2)

fibs1 :: [Integer]
fibs1 = map fib [0..]
 
fibs2 :: [Integer]
fibs2 = fib' 1 0 
  where fib' f1 f2 = [f1 + f2] ++ fib' f2 (f1 + f2)