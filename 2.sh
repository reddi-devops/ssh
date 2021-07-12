echo "Installing ssmtp"
yum install ssmtp -y
yum install ssmtp-2.61-11.5.3.x86_64.rpm -y
mv /sbin/sendmail /temp
ln -s /usr/sbin/ssmtp /usr/sbin/sendmail
cp -rp _smtp /etc/ssmtp/ssmtp.conf
service postfix restart
echo " adding email crotab"
crontab cron.sh
echo " Mail setup is testing"
/bin/echo `hostname`  "Server is up please be informed  "  | mail -s "Server is up at `date` " in.kishore2012@gmail.com,rk.middleware84@gmail.com,rk.mw84@gmail.com,rk.mw84@outlook.com,kishore@reddikishore.live,reddi.apple@gmail.com,reddi.devops@gmail.com,reddi.devops2@gmail.com,krkishore.was@gmail.com,mymailkishore@google-groups.com,rk.mw84@yahoo.com,kishore.devops@gmail.com,kishore.devops2@gmail.com,mw.kishore84@gmail.com
echo "Enabling GUI"
yum group install "Server with GUI" -y
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install xrdp tigervnc-server
rm /etc/xrdp/xrdp.ini
cp xrdp.ini /etc/xrdp/
systemctl start xrdp
systemctl enable xrdp
yum install nmon -y
yum install -y libXau.i686
yum install -y libXext.i686
yum install -y libxcb.i686
yum install -y compat-libstdc++-33.i686
yum install -y compat-db42.i686
yum install -y compat-db.i686
yum install -y compat-db43.i686
yum install -y libXi.i686
yum install -y libX11.i686
yum install -y libXtst.i686
yum install -y libXrender.i686
yum install -y libXft.i686
yum install -y libXt.i686
yum install -y libXp.i686
yum install -y libstdc++.i686
yum install -y libICE.i686
yum install -y compat-libtermcap.i686
yum install -y libidn.i686
yum install -y libSM.i686
yum install -y libuuid.i686
yum install -y gcc-c++
