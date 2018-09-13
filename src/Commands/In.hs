{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Commands.In
  ( module Commands.In
  ) where

import           Commands.Check         (resourceCheck)
import qualified Config                 as Config
import           Data.Aeson             ((.=))
import qualified Data.Aeson             as A
import qualified Data.ByteString.Lazy   as B
import           Data.Maybe             (fromMaybe)
import qualified Data.Vector            as V
import qualified GitHub.Endpoints.Repos as Repos
import qualified Handlers               as H
import qualified IOUtils
import qualified System.IO              as SIO
import qualified Types                  as T
import           Utils                  (unpackMaybe)


resourceIn :: SIO.FilePath -> Config.Input -> IO ()
resourceIn fPath (Config.Input {Config.source = src}) = do
  repos <- (IOUtils.unwrapErr . H.getRepos) src
  let repos' = fromMaybe [] (V.toList <$> repos)
  let version = T.toVersion repos'
  B.writeFile fPath (A.encode repos')
  let output = A.object ["version" .= version]
  B.putStr (A.encode output)

instance A.ToJSON Repos.Repo where
  toJSON r =
    A.object
      [ "name" .= (A.String . T.repoName) r
      , "updated_at" .= (Repos.repoUpdatedAt r)
      , "created_at" .= (Repos.repoCreatedAt r)
      ]
