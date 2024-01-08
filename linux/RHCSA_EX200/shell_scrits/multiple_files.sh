#!/bin/bash
# create multiple file with content

One command to create 26 empty files:

touch {a..z}.txt
or 152:

touch {{a..z},{A..Z},{0..99}}.txt
A small loop to create 152 files with some contents:

for f in {a..z} {A..Z} {0..99}
do
    echo hello > "$f.txt"
done
You can do numbered files with leading zeros:

for i in {0..100}
do
    echo hello > "File$(printf "%03d" "$i").txt"
done
or, in Bash 4:

for i in {000..100}
do
    echo hello > "File${i}.txt"
done




for i in {1..200}; do touch any_prefix_here${i}; done


echo Hello > a.txt
echo World > b.txt

for i in a b c d e f g; do
    echo $i > $i.txt
done





#!/bin/bash
# create a script like this (createNfiles.sh)

if [ "$1" = "" ]; then
  echo "Usage: $0 <number of files to create>"
  exit 1
fi

now=`date '+%Y-%m-%d_%H%M%S'`
prefix="${now}_myFilePrefix"
echo "creating $1 files"
echo "now=$now"

for i in $(seq 1 $1); do file="${prefix}_${i}.log"; echo "creating $file"; touch $file; done