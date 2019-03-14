module Problem2 where

-- balanced binary tree
-- foldr :: (a->b->b)->b->[a]->b

data Tree a = Leaf | Node Integer (Tree a ) a (Tree a)
  deriving (Show, Eq)

heightSubTree :: Tree a -> Integer
heightSubTree Leaf = 0
heightSubTree (Node h _ _ _) = h
 
balanceInsert :: a -> Tree a -> Tree a
balanceInsert a Leaf = Node 1 Leaf a Leaf
balanceInsert a (Node h tl ta tr) 
  | hl == hr  = Node (uhr+1) tl ta utr -- update upper nodes but the left subtree may not be updated otherwise children nodes have no difference
  | hl > hr   = Node h tl ta utr  -- insert and do not need update
  | otherwise = Node h (balanceInsert a tl) ta tr --insert and do not need update
  where hl = heightSubTree tl 
        hr = heightSubTree tr
        utr = balanceInsert a tr
        uhr = heightSubTree utr

foldTree :: [a] -> Tree a 
foldTree xs = foo $ foldr balanceInsert Leaf xs

foo :: Tree a -> Tree a
foo Leaf = Leaf
foo a@(Node h _ _ _) = foo' a h

foo' :: Tree a -> Integer -> Tree a
foo' Leaf _ = Leaf
foo' a@(Node h0 l m r) h = Node h (foo' l (h-1)) m (foo' r (h-1))   

showBalanceTree :: (Show a) => Tree a -> String
showBalanceTree Leaf = ""
showBalanceTree (Node h tl ta tr) = showBalanceTree tl ++ replicate (7*fromInteger h) ' ' ++ show ta ++ "("++ show h ++")\n" ++ showBalanceTree tr