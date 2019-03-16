module AParser where

import           Control.Applicative
import           Data.Char

newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

first :: (a -> b) -> (a,c) -> (b,c)
first f (a,c) = (f a, c)

instance Functor Parser where
  fmap f (Parser r) = Parser((fmap (first f)) . r)

instance Applicative Parser where
  pure a = Parser (\st -> Just (a, st))
  Parser rf <*> Parser ra =  Parser (\str -> case rf str of
                                       Just (f,str1) -> (case ra str1 of 
                                          Just(a, str2) -> Just (f a, str2);
                                          other -> Nothing);
                                       other -> Nothing
                                    )

instance Alternative Parser where
  empty = Parser (\st -> Nothing)    
  Parser ra <|> Parser rb = Parser (\s -> (ra s) <|> (rb s))

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f
  where
    f [] = Nothing    
    f (x:xs)                        
        | p x       = Just (x, xs)
        | otherwise = Nothing  

char :: Char -> Parser Char
char c = satisfy (== c)

posInt :: Parser Integer
posInt = Parser f
  where
    f xs
      | null ns   = Nothing
      | otherwise = Just (read ns, rest)
      where (ns, rest) = span isDigit xs

abParser :: Parser (Char,Char)
abParser = (\a b -> (a,b)) <$> char 'a' <*> char 'b'

abParser_ :: Parser ()
abParser_ = (\a b -> ()) <$> char 'a' <*> char 'b'

intPair :: Parser [Integer]
intPair = foo <$> posInt <*> char ' ' <*> posInt
      where foo a c b = [a,b]
                          
intOrUppercase :: Parser ()
intOrUppercase = intParse <|> ucParse 
    where intParse = (\x -> ()) <$> posInt
          ucParse = (\c -> ()) <$> (satisfy isUpper)
