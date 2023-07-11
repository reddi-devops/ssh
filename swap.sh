dd if=/dev/zero of=/root/linuxswapfile bs=1M count=3192
chmod 600 /root/linuxswapfile
mkswap /root/linuxswapfile
swapon /root/linuxswapfile
swapon -s
swapon -a