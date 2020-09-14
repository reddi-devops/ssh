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
echo " adding email crotab"
crontab cron.sh
/bin/echo `hostname`  "Server is up please be informed  "  | mail -s "Server is up at `date` " in.kishore2012@gmail.com,rk.middleware84@gmail.com,rk.mw84@gmail.com,rk.mw84@outlook.com,kishore@reddikishore.live,reddi.apple@gmail.com,reddi.devops@gmail.com,reddi.devops2@gmail.com,krkishore.was@gmail.com,mymailkishore@google-groups.com,rk.mw84@yahoo.com,kishore.devops@gmail.com,kishore.devops2@gmail.com,mw.kishore84@gmail.com
echo "Installing Kubernetes"
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
