#!/usr/bin/env bash

# Set timezone
timedatectl set-timezone Asia/Tokyo

yum -y update
yum -y install curl git unzip

# Install php 7.1
yum -y remove php*
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi-php71 php71 php71-php-cli php71-php-common php71-php-devel php71-php-json php71-php-mbstring php71-php-mysqlnd php71-php-pdo php71-php-process php71-php-xml php71-php-pecl-xdebug
ln -s /usr/bin/php71 /usr/bin/php

# nazo
# mkdir -p /vagrant/www/tmp/profile

sudo cat << EOS >> /etc/opt/remi/php71/php.d/15-xdebug.ini
html_errors=on
xdebug.collect_vars=on
xdebug.collect_params=4
xdebug.dump_globals=on
xdebug.dump.GET=*
xdebug.dump.POST=*
xdebug.show_local_vars=on
xdebug.remote_enable = on
xdebug.remote_autostart=on↲
xdebug.remote_handler = dbgp
xdebug.remote_connect_back=on↲
xdebug.profiler_enable=0
xdebug.profiler_output_dir="/vagrant/www/tmp/profile"
xdebug.max_nesting_level=1000
xdebug.remote_host=192.168.123.1
xdebug.remote_port = 9001
xdebug.idekey = "phpstorm"
EOS

cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# うまくいかない
# Install MySQL
yum remove -y mariadb-libs
yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum install -y mysql mysql-devel mysql-server mysql-utilities
# mysqld --user=mysql --initialize
# mv /home/vagrant/my.cnf /etc/my.cnf
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

# うまくいかない
# Install nginx
yum install -y nginx
# mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf
# mkdir -p /etc/nginx/sites-enabled
# mv /home/vagrant/app.conf /etc/nginx/sites-enabled/app.conf
# rm /etc/nginx/sites-enabled/default
sudo systemctl start nginx
sudo systemctl enable nginx

# # Install Redis
# apt-get -y install redis-server

# # Install nodejs, npm, yarn
# apt-get install -y nodejs npm
# npm cache clean
# npm install n -g
# n 8.9
# apt-get purge -y nodejs npm
# ln -sf /usr/local/bin/node /usr/bin/node
# ln -sf /usr/local/bin/npm /usr/bin/npm
# npm install -g yarn
