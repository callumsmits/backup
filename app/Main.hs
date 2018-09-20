module Main where

import qualified Config
import qualified System.Environment            as IO
import qualified System.Directory              as IO
import qualified System.IO                     as IO
import qualified System.Exit                   as IO
import System.FilePath
import qualified Data.List                     as List
import qualified Control.Monad                 as M


processDirectory :: FilePath -> IO ([FilePath], [FilePath], [FilePath])
processDirectory p = do
  ls <- map (p </>) <$> IO.listDirectory p
  files <- M.filterM IO.doesFileExist ls
  directories <- M.filterM IO.doesDirectoryExist ls
  print ls
  print files
  print directories
  return (ls, files, directories)  


main :: IO ()
main = do
  args <- IO.getArgs
  case args of
    (x : _) -> do
      c <- Config.loadConfig x
      case c of
        Left err -> IO.putStrLn $ "Error loading the config file: " <> show err
        Right conf -> mapM processDirectory (Config.directories conf) >>= print
    _ -> do
      IO.print "Read the readme"
      IO.exitFailure
