#!/usr/local/bin/bash
LIB="$1"
shift
SRC=$@
OBJ=()

TEMP=$(basename -- "$1")
EXT="${TEMP##*.}"

if [ "$EXT" == "cc" ]; then
  EXT="cpp"
fi

LIB="$HOME/local/libraries/$EXT/$LIB"

if [ -e "$LIB" ]; then
    echo "ERROR: $LIB already exists."
    exit 1
fi

function cleanup {
  for obj in $@; do
    rm $obj || (echo "ERROR: Failed removing $obj"; return 1)
  done
  return 0
}

for src in $SRC; do
  echo "Compiling $src"
  obj=${src%.*}.o
  $HOME/bin/compile.sh $obj $src -c &> /dev/null ||
    (echo "ERROR: Compilation failed."; cleanup ${OBJ[*]}; exit 2)
  OBJ+=($obj)
done

echo "Creating archive at $LIB"
/usr/bin/ar rcs $LIB ${OBJ[*]} && echo "Process complete." ||
  echo "ERROR: Failed creating archive."

cleanup ${OBJ[*]}
exit 0
