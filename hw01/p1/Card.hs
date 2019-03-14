module Card where

toDigitsRev' :: String -> [Integer]
toDigitsRev' (x:xs) = toDigitsRev' xs ++ [(case x of '0'->0; '1'->1; '2'->2; '3'->3; '4'->4; '5'->5; '6'->6; '7'->7; '8'->8; '9'->9; z->error "not digit")]
toDigitsRev' [] = []

toDigitsRev :: Integer -> [Integer]
toDigitsRev d = if d <= 0 then [] else toDigitsRev' (show d)

doubleEveryOther' :: [Integer] -> Bool -> [Integer]
doubleEveryOther' (x:xs) f= (doubleEveryOther' xs (not f)) ++ case f of True -> [2*x] ; False -> [x]; k->error "not bool"
doubleEveryOther' [] _ = []

doubleEveryOther :: Integer -> [Integer]
doubleEveryOther d = doubleEveryOther' (toDigitsRev d) False

sumDigits :: [Integer] -> Integer
sumDigits (x:xs) = sumDigits xs + x
sumDigits [] = 0

validate :: Integer -> Bool
validate x = if mod x 10 == 0 then True else False




