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
import           System.Environment    (getArgs)

main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  conf <-
    case decoded of
      Left err -> do
        IOUtils.writeErr err
        return Nothing
      Right conf -> return $ Just conf
  dirname <- parseDir
  let fn = \(conf, dir) -> Commands.resourceIn dir conf
  IOUtils.doMaybe fn (collect conf dirname)

parseDir :: IO (Maybe String)
parseDir = do
  args <- getArgs
  return $ Just $ head args

collect :: Maybe a -> Maybe b -> Maybe (a, b)
collect a b =
  case (a, b) of
    (Just a', Just b') -> Just (a', b')
    _                  -> Nothing
