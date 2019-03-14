module Stream where

data Stream a = Cons a (Stream a) 

instance Functor Stream where
  fmap f (Cons a s) = Cons (f a) (fmap f s)

instance Show a => Show (Stream a) where
  show st@(Cons a s) = show $ take 100 $ streamToList st

streamToList :: Stream a -> [a]
streamToList (Cons a s) = [a] ++ streamToList s

streamRepeat :: a -> Stream a
streamRepeat a = Cons a (streamRepeat a)

streamMap :: (a -> b) -> (Stream a) -> (Stream b)
streamMap = (<$>)

streamFromSeed :: (a -> a) -> a -> (Stream a)
streamFromSeed f a = Cons a $ streamFromSeed f $ f a

nats :: Stream Integer
nats = streamFromSeed (+1) 0 

-- we use tilde pattern to implement non-strict lazy evaluation by matching constructors
interleaveStreams :: Stream a -> Stream a -> Stream a
interleaveStreams (Cons a1 s1) ~(Cons a2 s2) = Cons a1 (Cons a2 (interleaveStreams s1 s2))

ruler :: Stream Integer
ruler = interleaveStreams (streamRepeat 0) ((+1) <$> ruler)