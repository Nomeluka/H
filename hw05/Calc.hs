module Calc where

    import ExprT
    import Expr
    import Parser

    -- Exercise 1
    eval :: ExprT -> Integer
    eval (Lit x) = x
    eval (Add e1 e2) = (eval e1) + (eval e2)
    eval (Mul e1 e2) = (eval e1) * (eval e2)
    
    -- Exercise 2
    getExprT :: Maybe ExprT -> Maybe Integer
    getExprT (Just exp) = Just (eval exp)
    getExprT Nothing = Nothing
    
    evalStr :: String -> Maybe Integer
    evalStr str = getExprT (parseExp Lit Add Mul str)
    
    -- Exercise 3
    instance Expr ExprT where
        lit a = Lit a
        add e1 e2 = Add e1 e2
        mul e1 e2 = Mul e1 e2

    -- when using (lit 1) in ghc directly, ghc cannot decide what type the expression is 
    -- thus we use (:: ExprT) to constrain the type to a definite instance of Expr 

    -- Exercise 3
    -- toExprT :: ExprT
    -- toExprT = mul (add (lit 2) (lit 3)) (lit 4)

    -- Exercise 4
    testExp :: Expr a => Maybe a
    testExp = parseExp lit add mul "1+2*3"
    
    instance Expr Integer where
        lit a = a
        add = (+)
        mul = (*)
    
    instance Expr Bool where
        lit a | a <= 0 = False
              | otherwise = True
        add =  (||)
        mul =  (&&)

    newtype MinMax = MinMax Integer deriving (Eq, Show)
    newtype Mod7 = Mod7 Integer deriving (Eq, Show)

    instance Expr MinMax where
        lit a = MinMax a
        add (MinMax a) (MinMax b) = MinMax $ max a b
        mul (MinMax a) (MinMax b) = MinMax $ min a b
    
    instance Expr Mod7 where
        lit a = Mod7 a
        add (Mod7 a) (Mod7 b) = Mod7 $ mod (a + b) 7
        mul (Mod7 a) (Mod7 b) = Mod7 $ mod (a * b) 7
    
    testInteger  = testExp :: Maybe Integer
    testBool  = testExp :: Maybe Bool
    testMinMax = testExp :: Maybe MinMax
    testMod7 = testExp :: Maybe Mod7

