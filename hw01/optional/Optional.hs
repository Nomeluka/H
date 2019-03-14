module Optional where

-- H(N) = min{H(N-X) + 2^(X)} - 1

weighList :: [Integer] -> Integer-> [Integer]
weighList (x:xs) i = [2^i+2*x - 1] ++ weighList xs (i-1)
weighList [] _ = []


exhanoi :: Integer -> [Integer]
exhanoi 1 = [1]
exhanoi x = al ++ [minimum $ weighList al (x-1)] where al = exhanoi (x-1)