module IOUtils
    ( module IOUtils
    ) where

propResultsM ::
     (Show a, Show b) => (a -> IO (Either b c)) -> IO (Maybe a) -> IO (Maybe c)
propResultsM fn x = x >>= maybe (return Nothing) (unwrapErr . fn)


propResults :: (Show a, Show b) => (a -> IO (Either b c)) -> Maybe a -> IO (Maybe c)
propResults fn x = maybe (return Nothing) (unwrapErr . fn) x

unwrapErr :: Show a => IO (Either a b) -> IO (Maybe b)
unwrapErr x = do
  res <- x
  case res of
    Left a -> do
      print a
      return Nothing
    Right b -> return (Just b)
