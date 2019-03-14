{-# LANGUAGE FlexibleInstances #-}

module CalcVM where

    import Expr
    import Parser
    import StackVM

    -- Exercise 5
    instance Expr Program where
        lit a = [PushI a]
        add a b = a ++ b ++ [Add]
        mul a b = a ++ b ++ [Mul]

    compile :: String -> Maybe Program
    compile = parseExp lit add mul 