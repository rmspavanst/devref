https://github.com/bitnami/containers/tree/main/bitnami/redmine#how-to-use-this-image

https://gist.github.com/brunojppb/bb5dbfacdbcb06ce6bd6303329ff2d72

https://redmine.org/projects/redmine/wiki/HowTo_Install_Redmine_on_Ubuntu_step_by_step

https://kifarunix.com/install-redmine-on-ubuntu/(22.04) working


https://unixcop.com/how-to-install-redmine-on-centos-8/


1. apt-get update -y
2. apt-get install apt-transport-https ca-certificates dirmngr gnupg2 -y

3. apt-get install apache2 apache2-dev libapache2-mod-passenger mariadb-server mariadb-client build-essential ruby-dev libxslt1-dev libmariadb-dev libxml2-dev zlib1g-dev imagemagick libmagickwand-dev curl -y

4. mysql

CREATE DATABASE redminedb CHARACTER SET utf8mb4;
GRANT ALL PRIVILEGES ON redminedb.* TO 'redmineuser'@'localhost' IDENTIFIED BY 'root123';

FLUSH PRIVILEGES;

exit;

5. useradd -r -m -d /opt/redmine -s /usr/bin/bash redmine

6. usermod -aG www-data redmine

7. su - redmine
wget --no-check-certificate https://www.redmine.org/releases/redmine-4.2.1.tar.gz

8. tar -xvzf redmine-4.2.1.tar.gz -C /opt/redmine/ --strip-components=1

9. cp /opt/redmine/config/configuration.yml{.example,}
cp /opt/redmine/public/dispatch.fcgi{.example,}
cp /opt/redmine/config/database.yml{.example,}

10. vi /opt/redmine/config/database.yml

11. Change the following lines:
production:
  adapter: mysql1
  database: redminedb
  username: redmineuser
  password: "root123"

12. cd /opt/redmine
gem install bundler

13. su - redmine
bundle install --without development test --path vendor/bundle

14. bundle exec rake generate_secret_token

15. RAILS_ENV=production bundle exec rake db:migrate
16. RAILS_ENV=production REDMINE_LANG=en bundle exec rake
17. redmine:load_default_date

18. for i in tmp tmp/pdf public/plugin_assets; do [ -d $i] || mkdir -p $i; done
19. chown -R redmine:redmine files log tmp public/plugin_assets
20. chmod -R 755 /opt/redmine

21. vi /etc/apache2/sites-avalible/redmine.conf

<VirtualHost *:80>
    ServerName redmine.ratulive.com
    RailsEnv production
    DocumentRoot /opt/redmine/public

    <Directory "/opt/redmine/public">
            Allow from all
            Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/redmine_error.log
    CustomLog ${APACHE_LOG_DIR}/redmine_access.log combined
</VirtualHost>


22. a2ensite redmine
23. systemctl reload apache2




cat > /etc/apache2/sites-available/redmine.conf << 'EOL'
Listen 3000
<VirtualHost *:3000>
	ServerName redmine.kifarunix-demo.com
	RailsEnv production
	DocumentRoot /opt/redmine/public

	<Directory "/opt/redmine/public">
	        Allow from all
	        Require all granted
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/redmine_error.log
        CustomLog ${APACHE_LOG_DIR}/redmine_access.log combined
</VirtualHost>
EOL
