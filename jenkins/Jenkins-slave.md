docker system prune -all


docker run --restart=always -d --name jenkins -p 8088:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11

docker update --restart unless-stopped $(docker ps -q)







https://www.coachdevops.com/2022/08/jenkins-build-agent-setup-using-docker.html

Pre-requisites:
Jenkins Master is already setup and running
port 8080 opened in Jenkins EC2's firewall rule
Setup Docker host. Creating another EC2 instance is recommended to serve as a Docker Host. 
port 4243 opened in docker host machine 
32768 - 60999 opened in docker host machine 


sudo vi /lib/systemd/system/docker.service

ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock

Restart Docker service
   sudo systemctl daemon-reload
   sudo service docker restart

Validate API by executing below curl command
curl http://localhost:4243/version


#Build Jenkins slave Docker image
Download Dockerfile from below repo.
git clone https://github.com/akannan1087/jenkins-docker-slave; cd jenkins-docker-slave

Build Docker image

sudo docker build -t my-jenkins-slave .




Dockerfile:
---------------
FROM ubuntu:18.04

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 11
    apt-get install -qy default-jdk && \
# Install maven
    apt-get install -qy maven && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:password" | chpasswd && \
    mkdir /home/jenkins/.m2

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]





