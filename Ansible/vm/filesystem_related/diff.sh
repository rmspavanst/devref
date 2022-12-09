#/usr/bin/diff -c /old_fdisk /new_fdisk | grep "! Disk /dev/sd*" | awk '{print $3}' | cut -d : -f 1,8
diff /old_lsblk /new_lsblk | grep "> sd*" | awk '{print $2}'
