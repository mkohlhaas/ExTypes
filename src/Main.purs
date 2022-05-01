module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

-- does not work:
-- newtype Showable = ∀ a. Show a => Showable a

newtype Showable = Showable (∀ r. (∀ a. Show a => a -> r) -> r)

mkShowable :: ∀ a. Show a => a -> Showable
mkShowable a = Showable (_ $ a)

-- the same:
-- mkShowable :: ∀ a. Show a => a -> Showable
-- mkShowable a = Showable \k -> k a
-- f x = f $ x = (_ $ x) f

instance Show Showable where
  show (Showable k) = k show

showables :: Array Showable
showables = [ mkShowable 1, mkShowable unit, mkShowable "hello" ]

main :: Effect Unit
main = log $ show showables -- [1,unit,"hello"]
