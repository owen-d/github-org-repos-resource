module Commands.Check
  ( module Commands.Check
  ) where

import qualified Config
import qualified Data.Aeson                 as A
import qualified Data.ByteString.Lazy       as B
import qualified Data.ByteString.Lazy.Char8 as C8
import           Data.Either.Combinators    (rightToMaybe)
import qualified Handlers
import qualified Types                      as T
import           Utils                      (unpackMaybe)


-- only report new version if there is a new version and it differs from last
resourceCheck :: Config.Input -> IO ()
resourceCheck input = do
  let lastVersion = Config.version input
  current <- Handlers.currentVersion input
  let currentVersion = (unpackMaybe . rightToMaybe) current
  let res =
        case (lastVersion, currentVersion) of
          (_, Just y)
            | lastVersion /= currentVersion -> [y]
          _ -> []
  C8.putStrLn (A.encode res)
