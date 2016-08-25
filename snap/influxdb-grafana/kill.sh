#!/bin/bash
source ~/.bash_aliases
dockerkill
kill -9 `pidof snapd`
shutdown now
