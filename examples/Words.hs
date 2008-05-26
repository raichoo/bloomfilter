import Control.Monad (forM_, mapM_)
import Data.BloomFilter.Easy
import qualified Data.ByteString.Char8 as B
import Data.Time.Clock
import System.Environment (getArgs)

main = do
  args <- getArgs
  let files | null args = ["/usr/share/dict/words"]
            | otherwise = args
  forM_ files $ \file -> do
    a <- getCurrentTime
    words <- B.lines `fmap` B.readFile file
    putStrLn $ {-# SCC "length words" #-} show (length words) ++ " words"
    b <- getCurrentTime
    putStrLn $ show (diffUTCTime b a) ++ "s to count words"
    let filt = {-# SCC "construct" #-} easyList 0.01 words
    print filt
    c <- getCurrentTime
    putStrLn $ show (diffUTCTime c b) ++ "s to construct filter"
    {-# SCC "query" #-} mapM_ print $ filter (not . (`elemB` filt)) words
    d <- getCurrentTime
    putStrLn $ show (diffUTCTime d c) ++ "s to query every element"
