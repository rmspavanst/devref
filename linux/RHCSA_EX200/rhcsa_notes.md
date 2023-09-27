sample exam que:
---------------
Q).    Set a proper target
    - set up default target on multi-user

A). systemctl get-default
    systemctl set-default multi-user.target


=================================================================================================================

Adding a new user:
---------------------

useradd student

This will result in an entry in the file /etc/passwd

grep student /etc/passwd
student:x:1000:1000::/home/student:/bin/bash


1 - Username - used when the user logs in - in our case student

2 - Password  - An x character means that an encrypted password is stored in /etc/shadow file

3 - User ID (UID) - a number assigned by Linux to each user on the system - in our case 2005

4 - Group ID (GID) - a numeric value used to represent a specific group, stored in /etc/group - in our case 2005

5 - User ID INFO (GECOS) - a field with an additional comment about the account - in our case is empty

6 - Home directory - path to the directory with user files - in our case /home/student

7 -  Command/Shell - path to the command or shell - in our case /bin/bash


Example1
Create a user named John with UID: 2500, comment: Employee and homedir: /home/employee

Solution
useradd -u 2500 -d /home/employee -c "Employee" John


Example2
Create a user named Bot with an option that interactive logins are not allowed for that user

Solution
useradd -s "/sbin/nologin" Bot



To check information about the user you can use commands:
id username

getent passwd username

Editing user settings
To change the UID of an existing user
usermod -u new_UID username



To add comment Sysadmin for user student
usermod -c "Sysadmin" student

To add user student additional supplementary group named students
usermod -aG students student


Default files for future users
The default directory where we can find files that are copied to the user home directory during user creating is

/etc/skel/

We can find there files like:
.bash_logout
.bash_profile
.bashrc

we can add/create any file

Removing user
To remove a user named student
userdel student

To remove user named student with his files
userdel -r student

===================================================================================================================

Changing password

To change the password for a user student use command
passwd student

User passwords by default are stored in /etc/shadow file

Password Management

To get more information about user password use the command:
chage -l username

Last password change - the date when the password was last changed
Password expires - the date when the password will expire
Password inactive - the date when the account will be locked due to expiration password
Account expires - the date when the account will expire
Minimum number of days between password change - number of days after which the user can change the password
Maximum number of days between password change - maximum age of the password
Number of days of warning before password expires - the number of days when the warning will begin to appear before the password expires


To set the password policy for a user student to change the password every 60 days
chage -M 60 student

To force the user student to change the password on the first login
chage -d 0 student

To set the account expiration date 20 days from the current day
date -d "+20 days" +%F
chage -E 2021-11-13 student

Setting policy passwords for future users
The default settings for the password policy and user settings can be found in the /etc/login.defs
To set that each new user will have to change the password every 30 days, edit the value PASS_MAX_DAYS to 30  in the file /etc/login.defs

==========================================================================================================================================
Adding new group

To add a new group use the command
groupadd group_name

You can verify the existence of a group using
getent group group_name
or
less /etc/group

Example1
Create a group named Admins with GID 5000
Solution
groupadd -g 5000 Admins

Example2
Set GID 6500 for group named Admins
Solution
groupmod -g 6500 Admins

To delete group use the command
groupdel group_name

==========================================================================================================================================
Popular options used with ls command

-l   use a long listing format
-a  do not ignore entries starting with . (hide files)
-h  print sizes
-i   print the index number of each file
-Z  print any security context of each file

r (4) - read - gives the ability to view the content of the file or allows list the files within the directory
w (2) - write - gives the ability to modify the content of the file or allows create, delete, rename files within the directory, and modify the directory's attributes
x (1) - execute - gives the ability to execute a program or allows them to enter the directory, and access files subdirectories inside

Example1
Allow everyone to read the new_file
Solution
chmod a+r new_file

Example2
Only the new_file owner should have read permissions
Solution
chmod o-rwx new_file
chmod g-rwx new_file

To change the owner of the file/directory use
chown owner_name new_file

To change a group of file/directory use
chown :group_name new_file

To change the owner of directory/subdirectories/files use
chown -R owner_name directory_name


Special Permissions

Effect of Special Permissions
SUID - u+s (4)  - file is executed as the user that owns the file - no impact on the directory
SGID - g+s (2)   - file is executed as the group that owns it - files created in the directory (with these special permissions) have the 

same group owner as a directory
STICKY - o+t (1)  - no impact on files - users with write permissions to directory with STICKY can only remove files that they own

Example1
Create collaborative directory /colla with Admins group owner that every file created in this directory should have group Admins
Solution
chmod g+s /colla
or
chmod 2775 /colla

==========================================================================================================================================
Types of links

Symbolic Link or Soft link
- Behaves as a shortcut in OS Windows
- Can link to a directory
- Has a different inode value than the original file

To create a symbolic link use
ln -s /path/to/file new_link

Hard Link
- When the original file is removed then the link will still show the content of the file
- Has same inode value as the original file
- Can only be used with regular files
- Can be used only on the same filesystem as original files

To create a hard link use
ln /path/to/file new_link

Creating links please provide an absolute path to file

==========================================================================================================================================
How to find interesting us items?

The basic tool to search items (files and directories) is find
We can search items using several filters:
Permissions
Owner
Group
Size
Date
Name
Type

Let's see how it works on several examples

Example1 
Find item named passwd in /etc directory
find /etc -name passwd

Example2
Find all files with owner student in the whole system
find / -user student -type f

Possible types of files:
f    - a regular file
d    - directory
l    - symbolic link
b    - block devices
s    - socket

Example3 
Find all files in /home directory with a size less than 2MB and show their size
find /home -size -2M -type f -exec du -h {} \;

Size options:
-      less than
+      greater than
k      Kilobytes
M      Megabytes
G      Gigabytes
exec option - allows executing command for found items "{}" - in the above case we use command du -h for every found item


Example4 
Find in /usr/share directory all shell scripts
find /usr/share -name "*.sh"

==========================================================================================================================================
Grep tool used to search for a string of characters in a specified file

How to use it?
grep word /path/to/file
                                   

List of examples
Example1
Find a word root in /etc/passwd file
grep root /etc/passwd

Example2
Find a word grub_timout in /etc/default/grub and show one line below the matched word
grep -i grub_timeout -A1 /etc/default/grub

-i, --ignore-case         ignore case distinctions
-A,                       print NUM lines of trailing context

Example3
Find a word student in all files in /etc directory
grep -r student /etc
-r, --recursive           like --directories=recurse

==========================================================================================================================================
Let's see some simple examples to explain this

Example1
Redirect output of the command echo "I can redirect" to the file new_redir
echo "I can redirect" > new_redir

Please note that the result of the above example is a new file new_redir with the content I can redirect
Now try to replace the text from the example above with the text I like

echo "I like" > new_redir

The last thing will be to append the word pizza in the above new_redir file

echo "pizza" >> new_redir

Example2
Redirect all lines which contains xfs from /etc/fstab to new file /tmp/fstab_xfs
grep xfs /etc/fstab > /tmp/fstab_xfs

Example3
Redirect errors (stderr) from used command to file /tmp/problems
grep -r 64 /proc/sys/net/ 2> /tmp/problems

Please notice that descriptor 2 with angle bracket > 2>  redirect only errors
Redirect standard output (stdout) and standard error (stderr) from used command to the file /tmp/all

grep -r 64 /proc/sys/net/ > /tmp/all 2>&1

What is Pipeline?
The pipeline allows us to serve output from one command as an input to the next command

Example1
Display and sort local users alphabetically
cat /etc/passwd | sort

Example2
Find whether process chronyd works using command ps aux and grep
ps aux | grep chronyd

==========================================================================================================================================
SCP - a tool to copy (transfer) files from one host to another in a secure way

Due to the fact that tool SCP uses an ssh connection, port 22 will be used by default
The next advantage of using by SCP tool ssh connection is the availability of authentication methods like:
Password
Public key

Lets see how to transfer files from one host to another in simple way
Example1
Copy the file text_file from node1 to node2 with destination /tmp
scp text_file node2:/tmp/

Example2
Copy directory old_files from node1 to node2 /tmp directory. Use account student to login to node2
scp -r old_files/ student@192.168.0.20:/tmp/


==========================================================================================================================================
Tar - tool to create archive and extract the archive files
Using the tar tool we can:
archive
compress
list
extract

How to archive and compress files?
Example1
Create an archive file with all files/directories from your home directory
tar -cvf my_home.tar ~

-c, --create         create a new archive
-f                   filename archive file
-v, --verbose        verbosely list files processed
~                    home directory

Create archive file with the file rhcsa1 rhcsa2 rhcsa3
tar -cvf my_archive.tar rhcsa1 rhcsa2 rhcsa3

Example2
Create a compressed gzip file with /etc directory
tar -cvzf my_garchive.tar.gz /etc

-c, --create                create a new archive
-f                          filename archive file
-v, --verbose               verbosely list files processed
-z, --gzip,                 filter the archive through gzip

Example3
Create a compressed bz2 file with /var/log directory
tar -cvjf my_barchive.tar.bz2 /var/log/
-c, --create                create a new archive
-f                          filename archive file
-v, --verbose               verbosely list files processed
-j, --bzip2                 filter the archive through bzip2

How to extract archived/compressed files?
Example1
Unarchive file my_home.tar to the current directory
tar -xvf my_home.tar

-x, --extract             extract files from an archive
-f                        filename archive file
-v, --verbose             verbosely list files processed

Example2
Uncompress bz2 file my_barchive.tar.bz2 to /tmp directory
tar -xvf my_barchive.tar.bz2 -C /tmp/

-C                          Change to Directory before performing any operations

How to list files in archived/compressed file?
Example1
List content of archived files from my_home.tar

tar -tvf my_archive.tar
-t, --list                     list the contents of an archive
-f                             filename archive file
-v, --verbose                  verbosely list files processed
==========================================================================================================================================
Shell script is a computer program designed to be run by the Linux shell

What is she-bang (#!) ?
She-bang is added at the head of a script and points to the path to the program that interprets the commands in the script (often bash, shell)

Creating first script
Below are several simple scripts and instructions

Example1
Create new file example1.sh

vim example1.sh
Add at the top she-bang to use bash interpreter
#!/bin/bash

Add below line to display sentence "My first script"
echo "My first script"

Save file and change permissions to execute the script
chmod +x example1.sh

Run the script
./example1.sh

Example2
Create new file example2.sh
vim example2.sh

Add at the top she-bang
#!/bin/bash

Add below code
for i in {1..10};
do
    echo "Number "$i
done

for    - loop iterates through a set of values (in our case numbers from 1 to 10) until the list is exhausted
$i      - it's our variable where will be replaced by numbers from 1 to 10 {1..10}

4. Save file and change permissions to execute the script
chmod +x example2.sh

5. Run Script
./example2.sh

==========================================================================================================================================
Schedule command, script to execute at the time that interests you

What is cron?
Cron is a command-line utility to schedule and execute jobs On the below image we can see the crontab (cron table) diagram from /etc/crontab - it's a system-wide file crontab

To set cron job we use
crontab -e
or edit file
vim /etc/crontab

Remember using crontab -e we edit file as a strict user and won't provide user-name in crontab
(using command crontab -e as a user student, we set up cron job only for the user student)
The created cron job for user student you will find in /var/spool/cron/root

Example1
Set the cron job for user root to post a message Logs message to logs every minute
1. Use the command on the user root
crontab -e

2. Add below the line and save the crontab :wq
* * * * * logger "Logs message"

3. Verify job execution by checking logs
less /var/log/cron

or to verify logger work use command
journalctl -xe | grep logger

Example2
Set job for a user student to execute every Saturday at 01:00 pm which appends output from command date to the file /tmp/date.txt
1. Edit file
vim /etc/crontab

2. Add below line
0 13 * * 6  student  echo $(date) >> /tmp/date.txt

Tip
For learning purposes, you can use generators from the Internet to train setting proper schedules
crontabguru
cronmaker

What is at?
At is also a tool to schedule jobs, but it has one main difference.
We can use At tool to execute one-time action, but we use cron to set regular repetitive jobs.

Example1
Set job at 18:00 to create empty file in /tmp/empty
1. Use the command
at 18:00
2. Write a required command to create a file, press enter, and use ctrl+d to save and exit
touch /tmp/empty
3. To see scheduled job use command
atq

How to delete At job?
atrm - deletes jobs, identified by their job number
To delete At job use
atrm job_identifier


==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

==========================================================================================================================================

