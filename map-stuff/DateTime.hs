module DateTime where

import Utils

data DateTime = DateTime { year :: Int
  , month :: Int
  , day :: Int
  , hour :: Int
  , minute :: Int
  , seconds :: Double }
  deriving Show

readDateTime :: String -> DateTime
readDateTime string = case getNumbers string of
  [year, minusMonth, minusDay, hour, minute, second, secondDecimal, _, _] -> 
    DateTime year (-minusMonth) (-minusDay) hour minute (read $ show second ++ "." ++ show secondDecimal)

