#!/usr/local/bin/bash
EXE_NAME=$1
shift
MAIN_NAME=$(basename -- "$1")
MAIN_EXT="${MAIN_NAME##*.}"
SRC=$@

case $MAIN_EXT in
  cc | cpp)
    /usr/bin/clang++ -o $EXE_NAME -std=c++17 -Wall $SRC
    ;;
  *)
    echo "Support for .$MAIN_EXT source code has not been implemented yet."
esac
