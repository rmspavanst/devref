#!/ban/bash
# des: ifthen-script

count=100
if [ $count -eq 100 ]
then
  echo Count is 100
else
  echo Count is not 100
fi



#!/ban/bash

clear
if [ -e /home/pavan/error.txt ]
    then
    echo "File exist"
    else
    echo "File does not exist"
fi 


#!/ban/bash

a= 'date | awk '{print $1}''
if [ "$a" == Mon ]
    then
    echo Today is $a
    else
    echo Today is not $a
fi 

#!/ban/bash
# Check the response and then output

clear
echo
echo "What is your name?"
read a
echo

echo Hello $a 
echo "Do you like working in IT? (y/n)"
read like
echo

if ["$Like" == y]
then
echo You are cool

elif [ "$Like" == n ]
then
echo You shoukd try IT, it's a good fiels
echo
fi




