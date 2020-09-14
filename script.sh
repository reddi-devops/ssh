#/bin/bash
echo " Enabling Root Login"
rm -rf /etc/ssh/ssh_config
sleep 5
rm -rf /etc/ssh/sshd_config
sleep 5
cp -rp ssh_config /etc/ssh/
sleep 5
cp -rp sshd_config /etc/ssh/
sleep 5
timedatectl set-timezone "Asia/Kolkata"
cp -rp banner1 /etc/ssh/
sleep 5
cp -rp inputrc /etc/
cp config /etc/selinux/
sleep 5
service sshd restart
sleep 5
#rmmod -v pcspkr
echo "Installing ssmtp"
sleep 5
yum install ssmtp-2.61-11.5.3.x86_64.rpm -y
sleep 5
mv /sbin/sendmail /temp
sleep 5
ln -s /usr/sbin/ssmtp /usr/sbin/sendmail
sleep 5
cp -rp _smtp /etc/ssmtp/ssmtp.conf
sleep 5
service postfix restart
sleep 5
/bin/echo `hostname`  "Server is up please be informed  "  | mail -s "Server is up at `date` " in.kishore2012@gmail.com,rk.middleware84@gmail.com,rk.mw84@gmail.com,rk.mw84@outlook.com,kishore@reddikishore.live,reddi.apple@gmail.com,reddi.devops@gmail.com,reddi.devops2@gmail.com,krkishore.was@gmail.com,mymailkishore@google-groups.com,rk.mw84@yahoo.com,kishore.devops@gmail.com,kishore.devops2@gmail.com,mw.kishore84@gmail.com

