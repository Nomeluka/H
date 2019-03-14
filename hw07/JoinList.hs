{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances, TypeSynonymInstances, InstanceSigs #-}

module JoinList where

import Data.Semigroup
import Data.Monoid
import Sized
import Scrabble
import Buffer

data JoinList m a = Empty
 | Single m a
 | Append m (JoinList m a) (JoinList m a)
 deriving (Eq, Show)

(+++) :: (Monoid m) => JoinList m a -> JoinList m a -> JoinList m a
(+++) l Empty = l
(+++) Empty l = l
(+++) l1@(Append m1 a1 b1) l2@(Append m2 a2 b2) = Append (m1 <> m2) l1 l2
(+++) l1@(Append m1 a1 b1) l2@(Single m2 a2) = Append (m1 <> m2) l1 l2
(+++) l1@(Single m1 a1) l2@(Single m2 a2) = Append (m1 <> m2) l1 l2
(+++) l1@(Single m1 a1) l2@(Append m2 a2 b2) = Append (m1 <> m2) l1 l2

tag :: Monoid m => JoinList m a -> m
tag Empty = mempty
tag (Single m a) = m
tag (Append m a b) = m

getSizeJ :: (Sized b, Monoid b, Semigroup b) => JoinList b a -> Int
getSizeJ Empty = 0
getSizeJ (Single m a) = getSize $ size m
getSizeJ (Append m a b) = getSize $ size m
--getSizeJ m = getSize $ size $ tag m

indexJ :: (Sized b, Monoid b, Semigroup b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty = Nothing
indexJ ix (Single b a) 
  | ix == 0 = Just a
  | otherwise = Nothing
indexJ ix lp@(Append b l1 l2)
  | (ix >= s0) || (ix < 0) = Nothing
  | ix < s1 = indexJ ix l1
  | otherwise = indexJ (subtract s1 ix) l2
  where 
    s0 = getSizeJ lp
    s1 = getSizeJ l1

takeJ ::  (Sized b, Monoid b, Semigroup b) => Int -> JoinList b a -> JoinList b a
takeJ _ Empty = Empty
takeJ c s@(Single b a)
  | c == 1 = s
  | otherwise = Empty
takeJ c lp@(Append b l1 l2) 
  | c <= 0 = Empty
  | c < s1 = takeJ c l1
  | c >= s0 = lp
  | c == s1 = l1
  | otherwise = l1 +++ (takeJ (subtract s1 c) l2)
  where 
  s0 = getSizeJ lp
  s1 = getSizeJ l1 

dropJ ::  (Sized b, Monoid b, Semigroup b) => Int -> JoinList b a -> JoinList b a
dropJ _ Empty = Empty
dropJ c s@(Single b a)
  | c == 0 = s
  | otherwise = Empty
dropJ c lp@(Append b l1 l2) 
  | c >= s0 = Empty
  | c < s1 = (dropJ c l1) +++ l2
  | c <= 0 = lp
  | c == s1 = l2
  | otherwise = dropJ (subtract s1 c) l2
  where 
  s0 = getSizeJ lp
  s1 = getSizeJ l1 

scoreLine :: String -> JoinList Score String
scoreLine str = Single (scoreString str) str

instance Buffer (JoinList (Score, Size) String) where

  toString :: JoinList (Score, Size) String -> String
  toString Empty = ""
  toString (Single _ s) = s++"\n"
  toString (Append _ l1 l2) = toString l1 ++ toString l2

  fromString :: String -> (JoinList (Score, Size) String)
  fromString s = Single (scoreString s, (Size 1)) s

  line :: Int -> (JoinList (Score, Size) String) -> Maybe String
  line = indexJ

  replaceLine :: Int -> String -> (JoinList (Score, Size) String) -> (JoinList (Score, Size) String)
  replaceLine i s Empty = Empty
  replaceLine i s j@(Single t a) 
    | i == 0 = Single ((scoreString s),(Size 1)) s
    | otherwise = j
  replaceLine i s j@(Append b l1 l2)
    | (i < 0) || (i >= n0) = j
    | i < n1 = replaceLine i s l1 +++ l2
    | otherwise = l1 +++ replaceLine (subtract n1 i) s l2
    where 
        n0 = getSizeJ j
        n1 = getSizeJ l1

  numLines :: JoinList (Score, Size) String -> Int
  numLines = getSizeJ 

  value :: JoinList (Score, Size) String -> Int
  value j = (\(Score a) -> a) $ fst $ tag j
  
buildJ :: String -> (JoinList (Score, Size) String)
buildJ s = Single ((scoreString s), (Size 1)) s