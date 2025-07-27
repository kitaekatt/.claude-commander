#!/bin/bash
# greet.sh - Helper script for the hello-world plugin
# Demonstrates how plugins can include executable scripts

# Get the current time of day
hour=$(date +%H)

# Determine appropriate greeting based on time
if [ $hour -lt 12 ]; then
    greeting="Good morning"
elif [ $hour -lt 17 ]; then
    greeting="Good afternoon"
else
    greeting="Good evening"
fi

# Output time-appropriate greeting
echo "$greeting! The current time is $(date +%H:%M)"