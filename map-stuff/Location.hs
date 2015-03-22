module Location where

import Utils

data Location = Location {lat :: Double, lon :: Double}
  deriving Show

readLocation :: String -> Location
readLocation string = case getNumbers string of
  [x1, x2, y1, y2, altitude] -> Location (combineNumbers x1 x2) (combineNumbers y1 y2)
    where
      combineNumbers x1 x2 = (read $ show x1 ++ "." ++ show x2) :: Double
