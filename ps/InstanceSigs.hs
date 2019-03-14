{-# LANGUAGE FlexibleInstances #-}

module L where  
    data MyType a b = A | B a b | C a (MyType a b) (MyType a b)

    class MyClass b where
        foo :: b -> b
    
    instance MyClass (MyType (String, Int) String) where
        foo A = A
        foo (B a b) = B (b, (snd a)) (fst a)
        foo (C a l1 l2) = l1
