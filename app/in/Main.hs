{-# LANGUAGE OverloadedStrings #-}

module Main
  ( main
  ) where

import qualified Commands
import qualified Config                as Config
import qualified Data.Aeson            as A
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy  as B
import           Data.Maybe            (maybe)
import qualified GitHub.Auth           as Auth
import qualified Handlers              as Handlers
import qualified IOUtils               as IOUtils

main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  conf <-
    case decoded of
      Left err -> do
        putStrLn err
        return Nothing
      Right conf -> return $ Just conf
  IOUtils.doMaybe (Commands.resourceIn "/tmp/repos.json") conf
