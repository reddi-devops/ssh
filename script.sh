#/bin/bash
pwd=`pwd`
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
yum install cockpit -y
yum install openssl* -y
systemctl enable cockpit
systemctl start cockpit
service sshd restart
#rmmod -v pcspkr
echo "Downloading files"
wget https://s3.us-east-2.amazonaws.com/kishore.middleware/jdk-8u241-linux-x64.tar.gz &
wget https://storage.googleapis.com/middlewarefiles/jdk-8u241-linux-x64.tar.gz &
wget https://storage.googleapis.com/middlewarefiles/httpd-2.4.46.tar.gz &
wget https://storage.googleapis.com/middlewarefiles/pcre-8.44.tar.gz &
wget https://storage.googleapis.com/middlewarefiles/tomcat-connectors-1.2.48-src.tar.gz &
wget https://storage.googleapis.com/middlewarefiles/jboss-eap-7.2.0.zip &
wget https://storage.googleapis.com/middlewarefiles/k9s &
chmod 777 *.tar.gz
chmod 777 *.zip
echo "Installing ssmtp"
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
yum install gcc-c++ -y
yum install wget -y
yum install expat-devel -y
yum remove java -y
echo " Downloading and setting up Jboss and apache"
slepp 30
tar -xzf jdk-8u241-linux-x64.tar.gz -C /opt/
rm -rf /root/.bash_profile
cp .bash_profile /root/
source /root/.bash_profile
echo "JAVA_HOME is " $JAVA_HOME
sleep 20
unzip jboss-eap-5.2.0.zip
mv jboss-eap-5.2 /opt/jboss52
export JBOSS=/opt/jboss52
cd $JBOSS/jboss-as/server
cp -rp all Node-1
cp -rp all Node-2
cp -rp all Node-3
cp -rp all Node-4

echo "Installing Kubernetes"

echo "Disabling swap"
swapoff -a
setenforce 0
echo "Disabling firewall"
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
systemctl stop firewalld
systemctl disable firewalld
echo "Firewall stopped"
#firewall-cmd --permanent --add-port=6443/tcp
#firewall-cmd --permanent --add-port=2379-2380/tcp
#firewall-cmd --permanent --add-port=10250/tcp
#firewall-cmd --permanent --add-port=10251/tcp
#firewall-cmd --permanent --add-port=10252/tcp
#firewall-cmd --permanent --add-port=10255/tcp
#firewall-cmd –reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
#cp kubernetes.repo /etc/yum.repos.d/
echo "Creating kubernetes repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
echo "Installing Kubernetes"
yum install kubeadm docker -y
systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker
echo " Initiating kubernetes cluster"
kubeadm init
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
echo " Please wait till the kube cluster comes up"
sleep 60
kubectl get nodes
echo "=========================================================="
yum remove java* -y
source /root/.bash_profile
echo  "JAVA_HOME is " $JAVA_HOME
echo "ALL are Done"
echo "Installing Apache"

#chmod 777 *.gz
#tar -xzf pcre-8.44.tar.gz
cd $pwd
sleep 10
chmod 777 pcre-8.44.tar.gz
echo "files are "
echo "=============================================================="
ls -ltr *.tar.gz
echo "============================================================="
sleep 30
chmod 777 httpd-2.4.46.tar.gz
chown -R root:root pcre-8.44.tar.gz
chown -R root:root httpd-2.4.46.tar.gz
tar -xzvf pcre-8.44.tar.gz
tar -xzvf httpd-2.4.46.tar.gz
chown -R root:root pcre-8.44
chown -R root:root httpd-2.4.46
sleep 10
cd pcre-8.44
sleep 10
./configure --prefix=/usr/pcre
sleep 20
make
sleep 20
make install
sleep 20
cd $pwd
tar -xzvf apache-maven-3.6.3-bin.tar.gz
mv apache-maven-3.6.3 /opt/mvn/
#itar -xzvf httpd-2.4.46.tar.gz
cd httpd-2.4.46
./configure --prefix=/opt/apache2446 --enable-so --enable-mods-shared=all --enable-proxy --with-pcre=/usr/pcre --enable-debug --enable-ssl
sleep 20
make
sleep 20
make install
cd $pwd
rm -rf jboss* jdk* httpd* pcre*
tar -xzvf tomcat-connectors-1.2.48-src.tar.gz
cd tomcat-connectors-1.2.48-src
cd native
./configure --prefix=/opt/jk/ --with-apxs=/opt/apache2446/bin/apxs
sleep 20
make
sleep 10
make install
cd $pwd
rm -rf tomcat*
echo "Installing and configuring s3cmd"
yum install s3cmd -y
cd $pwd 
cp -rp  awss3 /root/.s3cfg
chmod 777 jboss-eap-7.2.0.zip
unzip jboss-eap-7.2.0.zip
cp -rp jboss-eap-7.2 /opt/jboss721
mv jboss-eap-7.2 /opt/jboss722
cp k9s /usr/local/bin/
cp k9s /bin
source /root/.bash_profile
sleep 10
echo "done"
exit
