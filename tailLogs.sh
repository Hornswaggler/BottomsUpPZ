#!/bin/bash
tail -f ../../console.txt ../../coop-console.txt | awk '/==>/ {print ""; file=$2; next} {print file ": " $0}'