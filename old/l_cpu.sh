#!/bin/bash
#CPU Script
source /home/user/Desktop/loadgen/scenarios/c

#use mod epochtime to generate random spike
if [ "$SCENARIO_NUMBER" = 1 ]; then
	if [ $(($(date +"%s") % 25)) -gt $(shuf -i 1-15 -n 1) ]; then
	  ((CPUUPPER+=30)); ((CPULOWER+=35))
	fi
fi

n=$(shuf -i $CPULOWER-$CPUUPPER -n 1)

#clamp values over 100
if [ "$n" -gt "100" ]; then
echo -n 100
else echo -n $n
fi
