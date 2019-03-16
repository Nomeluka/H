module SExpr where

import AParser
import Control.Applicative
import Data.Char

zeroOrMore :: Parser a -> Parser [a]
zeroOrMore p = Parser (\s -> case runParser p s of 
                          Nothing -> Just ([],s); 
                          Just (x, sz) -> Just ([x] ++ a,b) 
                            where Just(a,b) = runParser (zeroOrMore p) sz
                      )

oneOrMore :: Parser a -> Parser [a]
oneOrMore p = Parser (\s -> case runParser p s of
                          Nothing -> Nothing; 
                          Just (x, sz) -> Just ([x] ++ a, b)
                            where Just(a,b) = runParser (zeroOrMore p) sz
                     )

spaces :: Parser String
spaces = zeroOrMore (satisfy isSpace)

ident :: Parser String
ident = (:) <$> (satisfy isAlpha) <*> (zeroOrMore (satisfy isAlphaNum))
{-
ident = Parser (\s -> case runParser (satisfy isAlpha) s of 
                      Nothing -> Nothing;
                      Just (c, cs) -> Just ([c] ++ c1, cs1)
                        where Just (c1, cs1) = runParser (zeroOrMore (satisfy isAlphaNum)) cs  
               )   
-}

type Ident = String

-- the parser of SExpr parses (123xyz) to Comb [A (N 123), A [I xyz]]. This is ignored in this parser
-- while we can implement the parser through monadic method

data Atom = N Integer | I Ident
  deriving Show

data SExpr = A Atom
           | Comb [SExpr]
  deriving Show

parseSExpr :: Parser SExpr
parseSExpr = spaces *> (listmod <|> idmod <|> intmod) <* spaces
 where listmod = char '(' *> ((\e -> \el -> Comb (e:el)) <$> parseSExpr <*> repmod) <* char ')' 
       idmod = (\i -> A (I i)) <$> ident
       intmod = (\x -> A (N x)) <$> posInt
       repmod = zeroOrMore (parseSExpr <* spaces)
