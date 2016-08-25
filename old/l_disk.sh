#!/bin/bash
#CPU Script
source /home/user/Desktop/loadgen/scenarios/c
shuf -i $DISKLOWER-$DISKUPPER -n 1 | awk '{printf $1}'
