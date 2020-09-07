#/bin/bash
echo " Enabling Root Login"
rm -rf /etc/ssh/ssh_config
rm -rf /etc/ssh/sshd_config
cp -rp ssh_config /etc/ssh/
cp -rp sshd_config /etc/ssh/
cp -rp banner1 /etc/ssh/
service sshd restart
rmmod -v pcspkr
yum install ssmtp* -y
mv /sbin/sendmail /temp
ln -s /usr/sbin/ssmtp /usr/sbin/sendmail
cp -rp ssmtp.conf_Working /etc/ssmtp/ssmtp.conf
service postfix restart
/bin/echo `hostname`  "Server is up please be informed  "  | mail -s "Server is up at `date` " in.kishore2012@gmail.com,rk.middleware84@gmail.com,rk.mw84@gmail.com,rk.mw84@outlook.com,kishore@reddikishore.live,reddi.apple@gmail.com,reddi.devops@gmail.com,reddi.devops2@gmail.com,krkishore.was@gmail.com,mymailkishore@google-groups.com,rk.mw84@yahoo.com,kishore.devops@gmail.com,kishore.devops2@gmail.com,mw.kishore84@gmail.com

