#!/bin/bash
# Script to add a user to Linux system
if [ $(id -u) -eq 0 ]; then
    read -p "Enter username : " username
    read -s -p "Enter password : " password
    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "$username exists!"
        exit 1
    else
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -p $pass $username
        [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
    fi
else
    echo "Only root may add a user to the system"
    exit 2
fi



#!/bin/bash
# to add user in multiple servers

servers=$(cat servers.txt)

echo -n "Enter the username: "
read name
echo -n "Enter the user id: "
read uid

for i in $servers; do
echo $i
ssh $i "sudo useradd -m -u $uid ansible"
if [ $? -eq 0 ]; then
echo "User $name added on $i"
else
echo "Error on $i"
fi
done