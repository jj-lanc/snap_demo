#!/bin/bash

#set random boundary variables based on local filename
name=$(basename $0)
upn=${name/%???/};upn+=u
lon=${name/%???/};lon+=l
source /home/user/Desktop/loadgen/scenarios/c
eval up=\$$upn
eval lo=\$$lon

#use mod epochtime to generate random spike
if [ "$scenario_number" = 4 ]; then

	  ((up=105)); ((lo=90))

fi

if [ "$scenario_number" = 1 ]; then
	  ((up=105)); ((lo=90))
fi
n=$(shuf -i $lo-$up -n 1)

#clamp values over 100
if [ "$n" -gt "100" ]; then
echo -n 100
else echo -n $n
fi

