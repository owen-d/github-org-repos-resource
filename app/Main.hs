{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified GitHub.Auth as Auth
import qualified Handlers as Handlers
import qualified Config as Config
import qualified Data.Aeson           as A
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Char8 as C8

main :: IO ()
main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  print decoded
