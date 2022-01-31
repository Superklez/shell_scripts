#!/usr/local/bin/bash
LIB="$HOME/local/libraries/$1"
shift
SRC=$@
OBJ=()

if [ -e "$LIB" ]; then
    echo "ERROR: $LIB already exists."
    exit
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
  $HOME/bin/compile.sh $obj $src -c &> /dev/null || \
    (echo "ERROR: Compilation failed."; cleanup ${OBJ[*]}; exit)
  OBJ+=($obj)
done

echo "Creating archive at $LIB"
/usr/bin/ar rcs $LIB ${OBJ[*]} && echo "Process complete." ||
  echo "ERROR: Failed creating archive."

cleanup ${OBJ[*]}
