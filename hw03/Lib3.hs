module Lib3 where

-- ex1
skips :: [a] -> [[a]]
skips xs = map (\(_,x) -> x) (map (\y -> unzip(filter (\(z,_) -> (mod z y)==0) (zip intl xs))) intl) where intl = [1..length(xs)]

-- ex2
localMaxima :: [Integer] -> [Integer]
localMaxima (x:y:z:xs) = if (y >= z && y >= x) then [y] ++ localMaxima ([y,z]++xs) else localMaxima([y,z] ++ xs)
localMaxima _ = []

-- ex3
histogram'' :: [Int] -> Int -> String
histogram'' [] _ = ['\n']
histogram'' (y:ys) x = if y >= x then ['*'] ++ histogram'' ys x else [' '] ++ histogram'' ys x

histogram' :: [Int] -> String
histogram' xs = concat $ map (\x -> histogram'' xs x) cnt where cnt = [1 .. maximum xs]

histogram :: [Integer] -> String
histogram xs = (histogram' $ map (\x -> length $ filter (\y -> y == x) xs) nat0) ++ "==========\n0123456789\n" where nat0 = [0..9] 