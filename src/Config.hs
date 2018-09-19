{-# LANGUAGE DeriveGeneric #-}

module Config
    ( loadConfig
    , ConfigJson
    , directories
    , ignoredFiles
    , encryptionPassword
    )
where


import           Data.Aeson
import           GHC.Generics
import qualified Data.ByteString.Lazy          as B


data RoughTimeOfDay = RoughTimeOfDay {
    hour :: Int,
    minute :: Int
} deriving (Show, Generic)


data ConfigJson = Config {
    startTime :: RoughTimeOfDay,
    endTime :: RoughTimeOfDay,
    directories :: [FilePath],
    ignoredFiles :: [String],
    encryptionPassword :: String
} deriving (Show, Generic)


instance FromJSON RoughTimeOfDay
instance FromJSON ConfigJson


getJSON :: String -> IO B.ByteString
getJSON = B.readFile

loadConfig :: FilePath -> IO (Either String ConfigJson)
loadConfig path = (eitherDecode <$> getJSON path) :: IO (Either String ConfigJson)
