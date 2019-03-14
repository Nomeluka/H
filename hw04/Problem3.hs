module Problem3 where

-- foldr :: (a -> b -> b) -> b -> [a] -> b

xor :: [Bool] -> Bool
xor bs = foldr (\a -> \b -> case a of True -> not b; z -> b) False bs

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\a -> \lb -> [f a] ++ lb) [] xs  


-- optional
--foldr :: (b -> a -> a) -> a -> [b] -> a -- f a (f b (f c z))
--myFoldl :: (a -> b -> a) -> a -> [b] -> a  -- f (f (f z a) b) c
--                                              -----------------
--                                                   f' c z    where z :: a1  f':: b -> a1 -> a1
--                                                   f' c z    = \p -> f p c z:: (a -> a) therefore a1 = (a -> a)  f' :: b -> (a -> a) -> (a -> a)
--                                                   f' b (f' c z)  =  \p -> f (f (\p) b) c z
--                                                   f' a (f' b (f' c z)) = \p -> f (f (f (\p) a) b) c z
myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f z xs = foldr (\c -> \g -> (\p -> g $ f p c)) id xs z