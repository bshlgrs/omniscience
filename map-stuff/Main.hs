module Main where

import DateTime
import Location
import Event
import Kml

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