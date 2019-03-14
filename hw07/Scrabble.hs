{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleInstances #-}

module Scrabble where

    import Data.Semigroup
    import Data.Monoid

    newtype Score = Score Int
     deriving (Num, Show, Eq, Ord)
    
    instance Monoid Score where
        mempty = Score 0

    instance Semigroup Score where
        (<>) = (+)

    score :: Char -> Score
    score c 
      | elem c "AEIOULNRSTaeioulnrst" = Score 1
      | elem c "DGdg" = Score 2
      | elem c "CBMPcbmp" = Score 3
      | elem c "FWYVHfwyvh" = Score 4
      | elem c "Kk" = Score 5
      | elem c "JXjx" = Score 8
      | elem c "QZqz" = Score 10  
      | otherwise = Score 0
    
    scoreString :: String -> Score
    scoreString = foldl (\x -> \c -> (score c) <> x) mempty 
