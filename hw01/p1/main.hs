module Main where

import Card 

main :: IO()
main = do
            d <- readLn
            print(validate $ sumDigits $ doubleEveryOther d)