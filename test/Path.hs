module Path (spec) where

import Prelude hiding (FilePath, writeFile)

import Data.ByteString.Char8 (pack)
import Filesystem (writeFile)
import Filesystem.Path.CurrentOS (FilePath)
import Filesystem.Path ((</>), filename)
import System.IO.FSNotify.Types (eventPath)
import System.IO.FSNotify.Path (canonicalizeDirPath, canonicalizePath, fp)
import Test.Hspec (describe, it, Spec)
import Test.HUnit ((@?=))
import Test.HUnit.Lang (Assertion, assertFailure)
import Util

always :: a -> Bool
always _ = True

never :: a -> Bool
never _ = False

hasTrailingSlash :: FilePath -> (FilePath -> IO FilePath) -> Assertion
hasTrailingSlash path canonicalizeFn = do
  let expected = '/'
  actualPath <- canonicalizeFn path
  let actual = last (fp actualPath)
  actual @?= expected

spec :: Spec
spec = do
  describe "canonicalizeDirPath" $ do
    it "Absolute path keeps trailing slash" $ do
      hasTrailingSlash (fp "/Users/") canonicalizeDirPath
    it "Absolute path gains trailing slash" $ do
      hasTrailingSlash (fp "/Users") canonicalizeDirPath
    it "Relative path keeps trailing slash" $ do
      hasTrailingSlash (fp "./") canonicalizeDirPath
    it "Relative path gains trailing slash" $ do
      hasTrailingSlash (fp ".") canonicalizeDirPath
  describe "canonicalizePath" $ do
    it "Absolute path keeps trailing slash" $ do
      hasTrailingSlash (fp "/Users/") canonicalizePath
    it "Relative path keeps trailing slash" $ do
      hasTrailingSlash (fp "./") canonicalizePath