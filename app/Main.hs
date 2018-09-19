module Main where

import qualified Config                        as Config
import qualified System.Environment            as IO
import qualified System.Directory              as IO
import qualified System.IO                     as IO
import qualified System.Exit                   as IO
import System.FilePath
import qualified Data.List                     as List
import qualified Control.Monad                 as M


listDir :: FilePath -> IO [FilePath]
listDir p = do
  items <- IO.listDirectory p
  let withPaths = map (\x -> p </> x) items
  return withPaths

run :: Config.ConfigJson -> IO ()
run config = do
  let paths = (Config.directories config)
  ls          <- mapM listDir paths
  files       <- mapM (M.filterM IO.doesFileExist) ls
  directories <- mapM (M.filterM IO.doesDirectoryExist) ls
  print ls
  print files
  print directories


main :: IO ()
main = do
  args <- IO.getArgs
  case args of
    (x : _) -> do
      c <- Config.loadConfig x
      case c of
        Left err -> IO.putStrLn $ "Error loading the config file: " <> show err
        Right conf -> run conf
    _ -> do
      IO.print "Read the readme"
      IO.exitFailure
