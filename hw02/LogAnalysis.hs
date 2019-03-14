module LogAnalysis where

import Log
 
parseInfo :: [String] -> LogMessage
parseInfo (x:stl) = LogMessage Info (read x::Int) (unwords(stl))

parseWarning :: [String] -> LogMessage
parseWarning (x:stl) = LogMessage Warning (read x::Int) (unwords(stl))

parseError :: [String] -> LogMessage
parseError (x:y:stl) = LogMessage (Error (read x::Int)) (read y::Int) (unwords(stl))

parseMessage :: String -> LogMessage
parseMessage st = case ts of "I" -> parseInfo dtsl; "W" -> parseWarning dtsl; "E" -> parseError dtsl; z -> Unknown st  
                  where tsl = words(st)
                        dtsl = drop 1 tsl
                        ts = head tsl
parseMessgae [] = []

parse' :: [String] -> [LogMessage]
parse' [] = []
parse' (x:xs) = [parseMessage x] ++ parse' xs

parse :: String -> [LogMessage]
parse log = parse' lineList where lineList = lines log

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) t = t
insert m Leaf = Node Leaf m Leaf
insert (LogMessage tp stmp str) (Node tl (LogMessage ttp tstmp tstr) tr) = if stmp >= tstmp 
                                                                           then Node tl (LogMessage ttp tstmp tstr) (insert (LogMessage tp stmp str) tr) 
                                                                           else Node (insert (LogMessage tp stmp str) tl) (LogMessage ttp tstmp tstr) tr

build :: [LogMessage] -> MessageTree
build (m:ms) = insert m $ build ms 
build [] = Leaf

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node tl tm tr) = inOrder(tl) ++ [tm] ++ inOrder(tr)

severityString :: [LogMessage] -> [String]
severityString ((LogMessage (Error i) stamp str):xs) = if i >= 50 then [str] ++ severityString(xs) else severityString(xs)
severityString (_:xs) = severityString(xs)
severityString [] = []