{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Commands.In
  ( module Commands.In
  ) where

import           Commands.Check             (resourceCheck)
import qualified Config                     as Config
import           Data.Aeson                 ((.=))
import qualified Data.Aeson                 as A
import qualified Data.ByteString.Lazy       as B
import qualified Data.ByteString.Lazy.Char8 as C8
import           Data.Maybe                 (fromMaybe)
import qualified Data.Vector                as V
import qualified GitHub.Endpoints.Repos     as Repos
import qualified Handlers                   as H
import qualified IOUtils
import System.FilePath.Posix ((</>), FilePath)
import qualified Types                      as T
import           Utils                      (unpackMaybe)

repoFile = "repos.json"

resourceIn :: FilePath -> Config.Input -> IO ()
resourceIn dirname (Config.Input {Config.source = src}) = do
  repos <- (IOUtils.unwrapErr . H.getRepos) src
  let repos' = fromMaybe [] (V.toList <$> repos)
  let version = T.toVersion repos'
  let fPath = dirname </> repoFile
  B.writeFile fPath (A.encode repos')
  let output = A.object ["version" .= version]
  C8.putStrLn (A.encode output)

instance A.ToJSON Repos.Repo where
  toJSON r =
    A.object
      [ "name" .= (A.String . T.repoName) r
      , "updated_at" .= (Repos.repoUpdatedAt r)
      , "created_at" .= (Repos.repoCreatedAt r)
      ]
