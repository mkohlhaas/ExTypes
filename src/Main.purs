module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

-- does not work:
-- newtype Showable = ∀ a. Show a => Showable a

-- hiding show method in a funcion:
-- newtype Showable = Showable ((∀ a. Show a => a -> String) -> String)

-- compiler can figure out String:
newtype Showable = Showable (∀ r. (∀ a. Show a => a -> r) -> r)

instance Show Showable where
  show (Showable k) = k show

mkShowable :: ∀ a. Show a => a -> Showable
mkShowable a = Showable (_ $ a)

-- mkShowable :: ∀ a. Show a => a -> Showable
-- mkShowable a = Showable \k -> k a
-- \k -> k a
-- \k -> k $ a
-- \k -> (_ $ a) k
-- η-reduction: (_ $ a)

showables :: Array Showable
showables = [ mkShowable 1, mkShowable unit, mkShowable "hello" ]

main :: Effect Unit
main = log $ show showables -- [1,unit,"hello"]
