module Problem4 where

pij :: Integer -> [Integer]
pij n = [ i + j + 2*i*j | i <- [1..n], j <- [1..n], i <= j, i + j + 2*i+j <= n ]


sieveSundaram :: Integer -> [Integer]
sieveSundaram n = [ 2*x + 1 | x <- [1..n] , elem x (pij n) == False]
