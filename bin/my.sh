#!/bin/sh
# auth optional pam_exec.so expose_authtok /home/juan/env/bin/my.sh
[ $PAM_USER = "juan" ] && gocryptfs -nosyslog /home/juan/.my.gocryptfs /home/juan/my
