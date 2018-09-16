{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Types
  ( module Types
  ) where

import qualified Data.Aeson             as A
import qualified Data.Aeson.Types       as AT
import qualified Data.ByteString.Char8  as C8
import qualified Data.ByteString.Lazy   as B
import qualified Data.Digest.Pure.SHA   as SHA
import qualified Data.HashMap.Strict    as HM
import qualified Data.Text              as Text
import qualified Data.Text              as T
import qualified GitHub.Data.Name       as Name
import qualified GitHub.Endpoints.Repos as Repos

-- Sha represents the hash of a list of repos
-- (May need to be modified later)
data Version =
  Version String
  deriving (Show, Eq)

toVersion :: [Repos.Repo] -> Maybe Version
toVersion [] = Nothing
toVersion repos =
  let convertRepo = C8.pack . T.unpack . repoName
      mkSha = Version . SHA.showDigest . SHA.sha1 . B.fromStrict
      mapped = map convertRepo repos
      joined = foldr C8.append "" mapped
      sha = mkSha joined
  in Just sha

instance A.ToJSON Version where
  toJSON (Version s) = A.object ["ref" A..= (A.String . T.pack) s]

repoName :: Repos.Repo -> T.Text
repoName = Name.untagName . Repos.repoName


instance A.FromJSON Version where
  parseJSON = A.withObject "Version" extractVersion

extractVersion :: AT.Object -> AT.Parser Version
extractVersion o =
  case HM.lookup "ref" o of
    Just (AT.String v) -> (return . Version . Text.unpack) v
    Just _ -> fail $ "invalid type for" ++ "ref"
    Nothing -> fail $ "failed to find" ++ "ref"
