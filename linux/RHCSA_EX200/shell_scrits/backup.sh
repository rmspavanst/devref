#!/bin/bash
#Taking backups is something that we all do on a regular basis so why not automate it

backup_dirs=("/etc" "/home" "/boot")
dest_dir="/backup"
dest_server="server1"
backup_date=$(date +%b-%d-%y)

echo "Starting backup of: ${backup_dirs[@]}"

for i in "${backup_dirs[@]}"; do
sudo tar -Pczf /tmp/$i-$backup_date.tar.gz $i
if [ $? -eq 0 ]; then
echo "$i backup succeeded."
else
echo "$i backup failed."
fi
scp /tmp/$i-$backup_date.tar.gz $dest_server:$dest_dir
if [ $? -eq 0 ]; then
echo "$i transfer succeeded."
else
echo "$i transfer failed."
fi
done

sudo rm /tmp/*.gzecho "Backup is done."





#!/bin/bash
# Monitoring available disk space

filesystems=("/" "/apps" "/database")
for i in ${filesystems[@]}; do
usage=$(df -h $i | tail -n 1 | awk '{print $5}' | cut -d % -f1)
if [ $usage -ge 90 ]; then
alert="Running out of space on $i, Usage is: $usage%"
echo "Sending out a disk space alert email."
echo $alert | mail -s "$i is $usage% full" your_email
fi
done