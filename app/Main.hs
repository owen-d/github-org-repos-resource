{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Config                as Config
import qualified Data.Aeson            as A
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy  as B
import           Data.Maybe            (maybe)
import qualified GitHub.Auth           as Auth
import qualified Handlers              as Handlers
import qualified IOUtils               as IOUtils
import qualified Commands

main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  conf <-
    case decoded of
      Left err -> do
        putStrLn err
        return Nothing
      Right conf -> return $ Just conf
  version <- IOUtils.doMaybe Commands.resourceCheck conf
  IOUtils.doMaybe print version

