module Main where
    
    import Party
    import Data.Tree
    import Employee
    import Data.List

    {-
    toFormat :: ([String],Integer) -> String
    toFormat p = "Total Fun : " ++ (show $ snd p) ++ "\n" ++ (concat $ fmap (\x -> x ++ "\n") $ sort $ fst $ p)

    nameList :: Tree Employee -> ([String], Integer)
    nameList = treeFold ([],0) (\(Emp s f) -> \bList -> ( ([s] ++ (nl bList)), (fl bList) + f ))
        where nl = concat . fst . unzip
              fl = sum . snd . unzip
    -}
    
    printGL :: GuestList -> String
    printGL g@(GL gl f) = "Total Fun : " ++ (show f) ++ "\n" ++ (concat $ sort (map (\(Emp e _) -> e ++ "\n") gl))
    

    foo :: String -> Tree Employee
    foo s = read s :: Tree Employee

    --main = readFile "company.txt" >>= putStrLn . toFormat . nameList . foo 
    main = readFile "company.txt" >>= putStrLn . printGL. maxFun . foo 