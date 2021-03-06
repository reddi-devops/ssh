#bin/bash
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
service sshd restart
#rmmod -v pcspkr
echo "Downloading files"
#wget https://s3.us-east-2.amazonaws.com/kishore.middleware/jdk-8u241-linux-x64.tar.gz &
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
