{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Handlers
  ( module Handlers
  ) where

import qualified Config                  as Config
import qualified Data.Vector             as V
import qualified GitHub.Auth             as Auth
import qualified GitHub.Data.Definitions as Def
import qualified GitHub.Data.Name        as Name
import qualified GitHub.Endpoints.Repos  as Repos
import           GitHub.Internal.Prelude (Text, pack, unpack)
import qualified Types                   as T

getRepos :: Config.Source ->  IO (Either Def.Error (V.Vector Repos.Repo))
getRepos Config.Source {api_key = auth, org = org} =
  Repos.organizationRepos'
    (Just auth)
    (Name.N $ pack org)
    Repos.RepoPublicityAll

printRepos :: Either Def.Error (V.Vector Repos.Repo) -> IO ()
printRepos x =
  case x of
    Left e  -> print e
    -- Right v -> mapM_ print v
    Right v -> print . T.toVersion . V.toList $ v
