module Utils where

import Data.Char (isDigit)

stringMinus :: String -> String -> String
stringMinus x y
  | prefix == y = suffix
  | otherwise = error "shit dude"
    where (prefix, suffix) = splitAt (length y) x

getNumbers :: String -> [Int]
getNumbers [] = []
getNumbers (x:xs)
  | x `elem` "0123456789" = (read (x:beginning)) : (getNumbers end)
  | x == '-' = (read (x:beginning)) : (getNumbers end)
  | otherwise = getNumbers xs
    where
      (beginning, end) = (takeWhile isDigit xs, dropWhile isDigit xs) -- this is optimizable

