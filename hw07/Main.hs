module Main where

    import Editor
    import JoinList

    main = runEditor editor $ ((buildJ "Yes" +++ buildJ ",") +++ (buildJ "It " +++ buildJ "Is") +++ buildJ "!")
    