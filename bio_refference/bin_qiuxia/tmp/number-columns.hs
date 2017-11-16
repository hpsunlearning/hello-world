{-# LANGUAGE OverloadedStrings, UnicodeSyntax #-}
import Control.Monad (liftM)
import Data.ByteString.Lazy.Char8 (ByteString)
import qualified Data.ByteString.Lazy.Char8 as LB
import System.Environment (getArgs)

numberColumns ∷ ByteString → ByteString
numberColumns s = LB.intercalate "\t" $ zipWith f [1..] (LB.split '\t' . head $ LB.lines s)
  where f a b = LB.pack (show a) `LB.append` ":" `LB.append` b

main = do
    [inFile] ← getArgs
    LB.putStrLn =<< liftM numberColumns (LB.readFile inFile)
