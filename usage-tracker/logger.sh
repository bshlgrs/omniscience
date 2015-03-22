#!/bin/bash

while true; do
  sleep 1
  echo `date -u` `osascript getWindowName.script` >> ~/.omniscience/computer_log
done