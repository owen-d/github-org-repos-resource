{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Config                as Config
import qualified Data.Aeson            as A
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy  as B
import qualified GitHub.Auth           as Auth
import qualified Handlers              as Handlers
import qualified IOUtils               as IOUtils
import Data.Maybe (maybe)

-- main = do
--   json <- B.getContents
--   let decoded = A.eitherDecode json :: Either String Config.Input
--   case decoded of
--     Left err -> putStrLn err
--     Right conf -> do
--       resp <- Handlers.getRepos (Config.source conf)
--       Handlers.printRepos resp

main = do
  json <- B.getContents
  let decoded = A.eitherDecode json :: Either String Config.Input
  let conf =
        case decoded of
          Left err -> do
            putStrLn err
            return Nothing
          Right conf -> return $ Just conf
  repos <- IOUtils.propResults (\x -> Handlers.getRepos (Config.source x)) conf
  maybe (return ()) Handlers.showRepos repos

-- main = do
--   json <- B.getContents
--   let decoded = A.eitherDecode json :: Either String Config.Input
--   repos <- case decoded of
--     Left err -> do
--       putStrLn err
--       return Nothing
--     Right conf ->
--       IOUtils.propResults
--         (\x -> Handlers.getRepos (Config.source x))
--         (return $ Just conf)
--   maybe (return ()) Handlers.showRepos repos
