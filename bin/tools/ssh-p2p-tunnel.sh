# add "PermitTunnel yes" to sshd_config
ssh \
  -o PermitLocalCommand=yes \
  -o LocalCommand='(sleep 3; ifconfig tun0 192.168.244.2 pointopoint 192.168.244.1 netmask 255.255.255.0)&' \
  -o ServerAliveInterval=60 \
  -w 0:0 root@server \
  '(sleep 3; ifconfig tun0 192.168.244.1 pointopoint 192.168.244.2 netmask 255.255.255.0) & echo tun0 ready'
