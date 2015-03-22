import Data.Char

data Kml = Kml [Event]
  deriving Show



data Event = Event {dateTime :: DateTime, location :: Location}
  deriving Show

data Location = Location {lat :: Double, lon :: Double}
  deriving Show

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

readLocation :: String -> Location
readLocation string = case getNumbers string of
  [x1, x2, y1, y2, altitude] -> Location (combineNumbers x1 x2) (combineNumbers y1 y2)
    where
      combineNumbers x1 x2 = (read $ show x1 ++ "." ++ show x2) :: Double


main = do
  readInitialStuff
  stuff <- readActualShit
  readEndStuff

  print stuff

  where
    readInitialStuff = do
      line <- getLine
      case line of
        "<altitudeMode>clampToGround</altitudeMode>" -> return ()
        _ -> readInitialStuff


    readActualShit :: IO [Event]
    readActualShit = do
      dateTime <- getLine
      case dateTime of
        "</gx:Track>" -> return []
        _ -> do
          location <- getLine
          let thisEvent = (Event (readDateTime dateTime) (readLocation location))
          rest <- readActualShit
          return $ thisEvent : rest

    readEndStuff = do
      line <- getLine
      case line of
        "</kml>" -> return ()
        _ -> readEndStuff