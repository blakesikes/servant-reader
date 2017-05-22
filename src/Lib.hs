{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Control.Monad.Trans.Reader
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type ReaderAPI = "a" :> Get '[JSON] Int :<|> "b" :> Get '[JSON] String

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve readerApi server

readerApi :: Proxy ReaderAPI
readerApi = Proxy

readerServerT :: ServerT ReaderAPI (ReaderT String Handler)
readerServerT = getMyInt :<|> getMyString

getMyInt :: ReaderT String Handler Int
getMyInt = return 123

getMyString :: ReaderT String Handler String
getMyString = ask

server :: Server ReaderAPI
server = enter (runReaderTNat "hello world") readerServerT
