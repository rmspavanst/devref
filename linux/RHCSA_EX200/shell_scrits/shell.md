Variables:
============

#!/bin/bash

var1=Hello
var2=rms

echo "$var1 $var2"

troubleshoot: bash -x var.sh

Parameters:
===========
#!/bin/bash
echo this script name is $0
#
echo the first argument is $1
echo the second argument is $2
echo the third argument is $3
#
echo \$ $$ PID of the script
echo \# $# Total number of arguments

./param.sh 1 5 90



Shift Through Parameters:
=========================
#!/bin/bash

if [ "$#" == "0" ]
 then
  echo pass at least one parameter
  exit 1
fi

while (( $# ))
 do
  echo you gave me $1
  shift
done

Read:
=====

#!/bin/bash
echo Enter your name :
read name

Sourcing a config file:
=======================
config.sh
#!/bin/bash
user=ansible
id=1201

main.sh
#!/bin/bash
source config.sh

echo "This is $user with $id."


getopts options:
===================
get.sh (with argument)

#!/bin/bash
while getopts ":abc" option; or while getopts ":ab:c" option;
do
 case $option in
 a)
  echo received -a
  ;;
 b)
  echo received -b or echo recived -b with $OPTARG
  ;;
 c)
  echo received -c or echo "option -$OPTARD
  ;;
esac
done

./get.sh -a
./get.sh -abc

