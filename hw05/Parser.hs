module Parser (parseExp) where
import Control.Applicative hiding (Const)
import Control.Arrow
import Data.Char
import Data.Monoid
import Data.List (foldl')

newtype State s r = State (s -> Maybe (r, s))

data Expr = Const Integer
          | Add Expr Expr
          | Mul Expr Expr
            deriving Show

instance Functor (State s) where
    fmap f (State g) = State $ fmap (first f) . g

instance Applicative (State s) where
    pure x = State $ \s -> Just (x, s)
    State f <*> State g = State $ \s ->
                          case f s of
                            Nothing -> Nothing
                            Just (r, s') -> fmap (first r) . g $ s'

instance Alternative (State s) where
    empty = State $ const Nothing
    State f <|> State g = State $ \s -> maybe (g s) Just (f s)

type Parser a = State String a

digit :: Parser Integer
digit = State $ parseDigit
    where parseDigit [] = Nothing
          parseDigit s@(c:cs)
              | isDigit c = Just (fromIntegral $ digitToInt c, cs)
              | otherwise = Nothing

num :: Parser Integer
num = maybe id (const negate) <$> optional (char '-') <*> (toInteger <$> some digit)
    where toInteger = foldl' ((+) . (* 10)) 0

space :: Parser ()
space = State $ parseSpace
    where parseSpace [] = Nothing
          parseSpace s@(c:cs)
              | isSpace c = Just ((), cs)
              | otherwise = Nothing

eatSpace :: Parser ()
eatSpace = const () <$> many space

char :: Char -> Parser Char
char c = State parseChar
    where parseChar [] = Nothing
          parseChar (x:xs) | x == c = Just (c, xs)
                           | otherwise = Nothing

op :: Parser (Expr -> Expr -> Expr)
op = const Add <$> (char '+') <|> const Mul <$> (char '*')

eof :: Parser ()
eof = State parseEof
    where parseEof [] = Just ((),[])
          parseEof _  = Nothing

parseExpr :: Parser Expr
parseExpr = eatSpace *>
            ((buildOp <$> nonOp <*> (eatSpace *> op) <*> parseExpr) <|> nonOp)
    where buildOp x op y = x `op` y
          nonOp = char '(' *> parseExpr <* char ')' <|> Const <$> num

execParser :: Parser a -> String -> Maybe (a, String)
execParser (State f) = f

evalParser :: Parser a -> String -> Maybe a
evalParser = (fmap fst .) . execParser

parseExp :: (Integer -> a) -> (a -> a -> a) -> (a -> a -> a) -> String -> Maybe a
parseExp con add mul= (convert <$>) . evalParser (parseExpr <* eof)   --(Maybe Expr -> Maybe ExprT) .  (String -> Maybe Expr)
    where convert (Const x) = con x
          convert (Add x y) = add (convert x) (convert y)
          convert (Mul x y) = mul (convert x) (convert y)

-- convert :: Expr -> ExprT
-- convert <$> :: unknownfunctor Expr -> unknownfunctor ExprT
-- parseExpr <* eof :: Parser Expr
-- evalParser (parseExpr <* eof) :: String -> Maybe Expr
-- (convert <$>) . evalParser (parseExpr <* eof) :: (unknownfunctor Expr -> unknownfunctor ExprT) . (String -> Maybe Expr)
-- ==> unknownfunctor = Maybe
-- (convert <$>) . evalParser (parseExpr <* eof) :: String -> Maybe ExprT