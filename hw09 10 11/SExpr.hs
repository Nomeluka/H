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

type Ident = String

-- the parser of SExpr parses (123xyz) to Comb [A (N 123), A [I xyz]]. This is ignored in this parser
-- while we can implement the parser through monadic method

data Atom = N Integer | I Ident
  deriving Show

data SExpr = A Atom
           | Comb [SExpr]
  deriving Show

-- We can add additional actions to a (Parser a) using <* or *>,
-- since the runParser in a Parser has been changed due to the <*> in <* or *>, 
-- although the same data type (Parser a)

parseSExpr :: Parser SExpr  
parseSExpr = spaces *> (listmod <|> idmod <|> intmod) <* spaces
 where listmod = char '(' *> (Comb <$> repmod) <* char ')' 
       idmod = (A . I)  <$> ident
       intmod = (A . N) <$> posInt
       repmod = oneOrMore parseSExpr
