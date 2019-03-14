module Problem1 where

fun1' :: [Integer] -> Integer
fun1' xs = foldl (\a -> \x -> a * (subtract 2 x) ) 1 $ filter even xs

fun2' :: Integer -> Integer
fun2' a = sum $ filter even $ takeWhile (> 1) $ iterate (\x -> if even x then x `div` 2 else 3*x + 1 ) a 