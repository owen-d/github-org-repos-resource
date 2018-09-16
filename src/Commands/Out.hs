module Commands.Out
  ( module Commands.Out
  ) where

import qualified IOUtils

resourceOut :: IO ()
resourceOut = IOUtils.writeErr "Out not inplemented."
