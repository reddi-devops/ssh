#/bin/bash
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
systemctl enable cockpit
systemctl start cockpit
service sshd restart
#rmmod -v pcspkr
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
yum remove java -y
echo " Downloading and setting up Jboss and apache"
wget https://s3.us-east-2.amazonaws.com/kishore.middleware/jdk-8u241-linux-x64.tar.gz
slepp 30
tar -xzf jdk-8u241-linux-x64.tar.gz -C /opt/
rm -rf /root/.bash_profile
cp .bash_profile /root/
source /root/.bash_profile
echo "JAVA_HOME is " $JAVA_HOME
wget https://s3.us-east-2.amazonaws.com/kishore.middleware/jboss-eap-5.2.0.zip
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

cp k9s /usr/local/bin/
cp k9s /bin/
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
echo "ALL are Done"
