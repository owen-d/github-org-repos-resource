{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Commands.In
  ( module Commands.In
  ) where

import           Commands.Check         (resourceCheck)
import qualified Config                 as Config
import           Data.Aeson             ((.=))
import qualified Data.Aeson             as A
import           Data.Maybe             (fromMaybe)
import qualified Data.Vector            as V
import qualified GitHub.Endpoints.Repos as Repos
import qualified Handlers               as H
import qualified IOUtils
import qualified Types                  as T
import           Utils                  (unpackMaybe)

resourceIn :: Config.Input -> IO ([Repos.Repo], Maybe T.Version)
resourceIn Config.Input {Config.source = src} = do
  repos <- (IOUtils.unwrapErr . H.getRepos) src
  let repos' = fromMaybe [] (V.toList <$> repos)
  let version = T.toVersion repos'
  return (repos', version)

instance A.ToJSON Repos.Repo where
  toJSON r =
    A.object
      [ "name" .= (A.String . T.repoName) r
      , "updated_at" .= (Repos.repoUpdatedAt r)
      , "created_at" .= (Repos.repoCreatedAt r)
      ]
