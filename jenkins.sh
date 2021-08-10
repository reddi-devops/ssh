#=================================
mkdir -p /jenkins/
cd /jenkins/
git clone https://gitlab.com/reddi.devops/jenkins-java.git
mv ./jenkins-java/*.tar.gz .
tar -xzvf java*.tar.gz
tar -xzvf apache*.tar.gz
rm -rf *.gz
cp -rp ./jenkins-java/jenkins.war ./apache*/webapps/
rm -rf ./jenkins-java/jenkins.war
./apache-tomcat-9.0.52/bin/startup.sh
#
