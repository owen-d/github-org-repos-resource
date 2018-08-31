{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified GitHub.Auth as Auth
import qualified Handlers as Handlers
import qualified Config as Config
import qualified Data.Aeson           as A
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Char8 as C8

main :: IO ()
-- main = Handlers.getRepos conf >>= Handlers.printRepos
main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  case decoded of
    Left err -> putStrLn err
    Right conf -> do
      resp <- Handlers.getRepos (Config.source conf)
      Handlers.printRepos resp


-- [Show e => a -> IO (either e b)]
-- want fn that invokes on
