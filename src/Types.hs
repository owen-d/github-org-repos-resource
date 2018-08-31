{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Types
  ( module Types
  ) where

import qualified Data.ByteString.Char8  as BC
import qualified Data.ByteString.Lazy   as B
import qualified Data.Digest.Pure.SHA   as SHA
import qualified Data.Text              as T
import qualified GitHub.Data.Name       as Name
import qualified GitHub.Endpoints.Repos as Repos

-- Sha represents the hash of a list of repos
-- (May need to be modified later)
data Version =
  Version String
  deriving (Show)

toVersion :: [Repos.Repo] -> Maybe Version
toVersion [] = Nothing
toVersion repos =
  let convertRepo = BC.pack . T.unpack . Name.untagName . Repos.repoName
      mkSha = Version . SHA.showDigest . SHA.sha1 . B.fromStrict
      mapped = map convertRepo repos
      joined = foldr BC.append "" mapped
      sha = mkSha joined
  in Just sha
