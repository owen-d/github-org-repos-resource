module Utils
    ( module Utils
    ) where

import           Data.Maybe (fromMaybe)

unpackMaybe :: Maybe (Maybe a) -> Maybe a
unpackMaybe = fromMaybe Nothing
