#!/usr/local/bin/bash -h

# Renames all cbz files to a desired format. This script assumes that the
# numbers in the file name follow the format CCC (YYYY) if it's a chapter or
# vVV (YYYY) if it's a volume.

function rename_volume() {
  local NUMBERS=$(echo "$1" | sed 's/[^0-9]*//g')
  local VOLUME=$(echo $NUMBERS | cut -c1-2)
  VOLUME=$(echo $VOLUME | sed -r 's/0*([0-9]*)/\1/')
  local YEAR=$(echo $NUMBERS | cut -c3-6)
  NEW_NAME="$(echo "$1" | cut -d' ' -f1-$NUM_WORDS) Vol. $VOLUME ($YEAR).cbz"
}

function rename_chapter() {
  local NUMBERS=$(echo "$1" | sed 's/[^0-9]*//g')
  local CHAPTER=$(echo $NUMBERS | cut -c1-3)
  CHAPTER=$(echo $CHAPTER | sed -r 's/0*([0-9]*)/\1/')
  local YEAR=$(echo $NUMBERS | cut -c4-7)
  NEW_NAME="$(echo "$1" | cut -d' ' -f1-$NUM_WORDS) Ch. $CHAPTER ($YEAR).cbz"
}

TEST=${1:-true}
read -p "Number of words to keep in each file name: " NUM_WORDS

for FILE in *.cbz
do 
  if [[ "$FILE" == *v[0-9]* ]]
  then
    rename_volume "$FILE"
  else
    rename_chapter "$FILE"
  fi
  echo "Renaming $FILE to $NEW_NAME"
  if ! $TEST
  then
    mv "$FILE" "$NEW_NAME"
  fi
done
