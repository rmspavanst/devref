sudo yum -y update
sudo reboot

sudo amazon-linux-extras install java-openjdk11

sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
$ getent passwd tomcat
$ getent group tomcat


sudo yum -y install wget
export VER="9.0.63"
wget https://archive.apache.org/dist/tomcat/tomcat-9/v${VER}/bin/apache-tomcat-${VER}.tar.gz
sudo tar xvf apache-tomcat-${VER}.tar.gz -C /usr/share/
sudo ln -s /usr/share/apache-tomcat-$VER/ /usr/share/tomcat

sudo chown -R tomcat:tomcat /usr/share/tomcat
sudo chown -R tomcat:tomcat /usr/share/apache-tomcat-$VER/

# The /usr/share/tomcat directory has the following sub-directories:

# bin: contains the binaries and scripts (e.g startup.sh and shutdown.sh for Unixes and Mac OS X).
# conf: contains the system-wide configuration files, such as server.xml, web.xml, and context.xml.
# webapps: contains the webapps to be deployed. You can also place the WAR (Webapp Archive) file for deployment here.
# lib: contains the Tomcat’s system-wide library JAR files, accessible by all webapps. You could also place external JAR file (such as MySQL JDBC Driver) here.
# logs: contains Tomcat’s log files. You may need to check for error messages here.
# work: Tomcat’s working directory used by JSP, for JSP-to-Servlet conversion.


## Create Tomcat Systemd service:
sudo tee /etc/systemd/system/tomcat.service<<EOF
[Unit]
Description=Tomcat Server
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment='JAVA_OPTS=-Djava.awt.headless=true'
Environment=CATALINA_HOME=/usr/share/tomcat
Environment=CATALINA_BASE=/usr/share/tomcat
Environment=CATALINA_PID=/usr/share/tomcat/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M'
ExecStart=/usr/share/tomcat/bin/catalina.sh start
ExecStop=/usr/share/tomcat/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat


sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload


sudo vim /usr/share/tomcat/conf/tomcat-users.xml

<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="admin" password="TomcatAdminPassw0rd" fullName="Administrator" roles="admin-gui,manager-gui"/>


# Configure Apache web server as a proxy for Tomcat server. First install httpd package.
sudo yum -y install httpd 

sudo vim /etc/httpd/conf.d/tomcat_manager.conf

<VirtualHost *:80>
    ServerAdmin root@localhost
    ServerName tomcat.example.com
    DefaultType text/html
    ProxyRequests off
    ProxyPreserveHost On
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
</VirtualHost>

## Where:

# hirebestengineers.com is the DNS name of your tomcat server.
# For AJP connector, it will be configuration like this:

<VirtualHost *:80>
  ServerName ajp.example.com

  ProxyRequests Off
  ProxyPass / ajp://localhost:8009/
  ProxyPassReverse / ajp://localhost:8009/
</VirtualHost>

##  If SELinux is enabled run the following commands:

sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_can_network_relay 1
sudo setsebool -P httpd_graceful_shutdown 1
sudo setsebool -P nis_enabled 1


# Restart httpd service:

sudo systemctl restart httpd
sudo systemctl enable httpd





