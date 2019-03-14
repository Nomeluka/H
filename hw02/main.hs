module Main where

import LogAnalysis
import Control.Applicative
main = do
        s <- readFile "error.log"
        print $ severityString $ inOrder $ build $ take 3 $ parse s