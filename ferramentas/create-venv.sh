#!/bin/bash
py3_location=$(which python3)

if [ -d "$1" ]; then
    echo "Virtual env directory already exists... Skipping!"
else
    virtualenv -p "$py3_location" $1  
fi
