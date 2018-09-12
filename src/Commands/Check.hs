module Commands.Check
  ( module Commands.Check
  ) where

import qualified Types as T
import qualified Config
import qualified Handlers
import Data.Either.Combinators (rightToMaybe)
import Data.Maybe (fromMaybe)

unpackMaybe :: Maybe (Maybe a) -> Maybe a
unpackMaybe = fromMaybe Nothing

-- only report new version if there is a new version and it differs from last
resourceCheck :: Config.Input -> IO [T.Version]
resourceCheck input = do
  let lastVersion = Config.version input
  current <- Handlers.currentVersion input
  let currentVersion = (unpackMaybe .rightToMaybe) current

  let res =
        case (lastVersion, currentVersion) of
          (_, Just y)
            | lastVersion /= currentVersion -> [y]
          _ -> []
  return res
