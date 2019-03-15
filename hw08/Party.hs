module Party where

    import Employee
    import Data.Tree
    import Data.Monoid
    import Data.Semigroup 

    instance Semigroup GuestList where
      (<>) g1@(GL l1 f1) g2@(GL l2 f2) = GL (l1 ++ l2) (f1 + f2)

    instance Monoid GuestList where
      mempty = GL [] 0

    glCons :: Employee -> GuestList -> GuestList
    glCons e@(Emp _ f) (GL el fun) = GL (e:el) (fun + f)

    moreFun :: GuestList -> GuestList -> GuestList
    moreFun gl1@(GL _ f1) gl2@(GL _ f2) 
      | f1 >= f2 = gl1
      | otherwise = gl2

    nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList) --(B, no B)
    nextLevel e [] = (glCons e mempty , mempty)
    nextLevel e gpl = (x1, x2)
        where x1 = glCons e (foldl (<>) mempty gpl2)
              x2 = foldl (<>) mempty (map (\x -> moreFun (fst x) (snd x)) gpl)
              gpl2 = snd $ unzip gpl

    maxFun :: Tree Employee -> GuestList 
    maxFun n@(Node e frst) = moreFun (fst x) (snd x)
      where x = maxFun' n 
            maxFun' = treeFold (mempty,mempty) nextLevel 
            --maxFun' (Node e frst) = nextLevel e (map maxFun' frst)
    
    treeFold :: b -> (a -> [b] -> b) -> Tree a -> b
    treeFold b f (Node a []) = f a []
    treeFold b f (Node a ts) = f a (map (treeFold b f) ts) 