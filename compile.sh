#!/usr/local/bin/bash
NAME=$1
shift
FILE=$@
/usr/bin/clang++ -o $NAME -std=c++17 -Wall $FILE
