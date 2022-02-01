#!/usr/local/bin/bash
LIB="$1"
LIB_EXT="${LIB##*.}"

shift
SRC=$@

TEMP="$1"
SRC_EXT="${TEMP##*.}"

if [ "$SRC_EXT" == "cc" ]; then
  SRC_EXT="cpp"
fi

LIB="$HOME/local/libraries/$SRC_EXT/$LIB"

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

if [ "$LIB_EXT" == "dylib" ]; then
  # Dynamic library
  echo "Creating dynamic library at $LIB"
  $HOME/bin/compile.sh $LIB $SRC -fPIC -shared ||
    (echo "ERROR: Failed creating dynamic library."; exit 2)

elif [ "$LIB_EXT" == "a" ]; then
  # Static library
  OBJ=()
  for src in $SRC; do
    echo "Compiling $src"
    obj=${src%.*}.o
    $HOME/bin/compile.sh $obj $src -c &> /dev/null ||
      (echo "ERROR: Compilation failed."; cleanup ${OBJ[*]}; exit 2)
    OBJ+=($obj)
  done

  echo "Creating archive at $LIB"
  /usr/bin/ar rcs $LIB ${OBJ[*]} && echo "Process complete." ||
    (echo "ERROR: Failed creating archive."; exit 3)

  cleanup ${OBJ[*]}

else
  echo "ERROR: Unsupported library extension."
  exit 4
fi
exit 0
