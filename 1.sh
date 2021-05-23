echo "==================================================================="
echo " Script for enabling required features "
echo " Enabling Root Login"
rm -rf /etc/ssh/ssh_config
rm -rf /etc/ssh/sshd_config
cp -rp ssh_config /etc/ssh/
cp -rp sshd_config /etc/ssh/
echo "Setting IST TimeZone"
sleep 2
timedatectl set-timezone "Asia/Kolkata"
echo "setting banner"
cp -rp banner1 /etc/ssh/
sleep 2
cp -rp inputrc /etc/
echo "disabling Selinux"
cp config /etc/selinux/
echo "Installing Cockpit"
yum install cockpit openssl* wget unzip -y
systemctl enable cockpit
systemctl start cockpit
service sshd restart
