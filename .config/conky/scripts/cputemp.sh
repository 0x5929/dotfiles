#!/bin/bash

# Main
cpuTemp=$(sensors | grep 'Intel PECI' | head -1 | awk -F '+' '{print $2}' | grep -o -P '.{0,10}.C')

if [[ -n $cpuTemp ]]; then 
    echo "$cpuTemp"; 
else 
    echo "n/a"; 
fi

exit
