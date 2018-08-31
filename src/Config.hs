{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Config
  ( module Config
  ) where

import           Data.Aeson              (FromJSON, (.:), (.:?))
import qualified Data.Aeson              as A
import qualified Data.Aeson.Types        as AT
import qualified Data.ByteString.Char8   as C8
import qualified Data.HashMap.Strict     as HM
import qualified Data.Text               as Text
import qualified GitHub.Auth             as Auth
import qualified GitHub.Data.Definitions as Def
import qualified Types                   as T


data Input = Input
  { source  :: Source
  , version :: Maybe T.Version
  }
  deriving (Show)

instance FromJSON Input where
  parseJSON = A.withObject "Input" $ \v ->
    Input <$> v .: "source"
      <*> v .:? "version"

instance FromJSON T.Version where
  parseJSON = A.withText "Version" $ \v ->
    return . T.Version .Text.unpack $ v

data Source = Source
  { api_key :: Auth.Auth
  , org     :: String
  }
  deriving (Show)

instance FromJSON Source where
  parseJSON = A.withObject "Source" $ \v ->
    Source <$> parseApiKey v
      <*> v .: "org"


parseApiKey :: AT.Object -> AT.Parser Auth.Auth
parseApiKey o = case HM.lookup "api_key" o of
  Just (AT.String v) -> return $ Auth.OAuth . C8.pack . Text.unpack $ v
  Just _             -> fail $ "invalid type for" ++ "api_key"
  Nothing            -> fail $ "failed to find" ++ "api_key"
