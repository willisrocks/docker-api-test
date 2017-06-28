#!/bin/bash
#echo "$1" > /userfile
useradd $SESSION_USER -s /bin/bash -m
echo "$SESSION_USER:password" | chpasswd
mkdir -p /home/$SESSION_USER/.ssh
echo "$SESSION_KEY" > /home/$SESSION_USER/.ssh/authorized_keys
chown $SESSION_USER:$SESSION_USER /home/$SESSION_USER/.ssh/authorized_keys
chmod 700 /home/$SESSION_USER/.ssh
chmod 600 /home/$SESSION_USER/.ssh/authorized_keys

/usr/sbin/sshd -D
