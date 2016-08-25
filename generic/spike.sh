#!/bin/bash

n=$(shuf -i 0-15 -n 1)

#clamp values over 100
if [ "$n" -gt "13" ]; then
echo -n $(shuf -i 60-100 -n 1)
else echo -n $n
fi

