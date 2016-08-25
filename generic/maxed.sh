#!/bin/bash
n=$(shuf -i 92-120 -n 1)

#clamp values over 100
if [ "$n" -gt "100" ]; then
echo -n 100
else echo -n $n
fi
