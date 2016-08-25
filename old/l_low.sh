#!/bin/bash
#shuf -i 0-5 -n 1 | awk '{printf $1}'

echo -n $(shuf -i 0-5 -n 1)
