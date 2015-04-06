#!/bin/bash

while true; do
  sleep 60
  echo `date -u` `osascript getWindowName.script` >> ~/.omniscience/computer_log2
done