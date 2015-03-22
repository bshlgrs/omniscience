module Event where

import Location
import DateTime

data Event = Event {dateTime :: DateTime, location :: Location}
  deriving Show