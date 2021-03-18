#!/bin/sh
# auth optional pam_exec.so expose_authtok /juan/env/bin/my.sh
[ $PAM_USER = "juan" ] && gocryptfs -nosyslog -allow_other ~juan/.my.gocryptfs ~juan/my
