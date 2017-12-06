#!/usr/bin/env bash

# Set timezone
timedatectl set-timezone Asia/Tokyo

yum -y update
yum -y install curl git unzip

# Install php 7.1
yum -y remove php*
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y install --enablerepo=remi-php71 php71 php71-php-cli php-fpm php71-php-common php71-php-devel php71-php-json php71-php-mbstring php71-php-mysqlnd php71-php-pdo php71-php-process php71-php-xml php71-php-pecl-xdebug
ln -s /usr/bin/php71 /usr/bin/php

mkdir -p /vagrant/www/tmp/profile

sudo cat << EOS >> /etc/php.d/15-xdebug.ini
zend_extension=/opt/remi/php71/root/usr/lib64/php/modules/xdebug.so
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

# Setting for php-fpm
mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.orig
mv /home/vagrant/www.conf /etc/php-fpm.d/www.conf

# Install MySQL
yum remove -y mariadb-libs
yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum install -y mysql mysql-devel mysql-server mysql-utilities
# mysqld --user=mysql --initialize
cp -a /etc/my.cnf /etc/my.cnf.orig
mv /home/vagrant/my.cnf /etc/my.cnf
systemctl start mysqld.service
systemctl enable mysqld.service

# Install nginx
yum install -y nginx
cp -a /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf
systemctl start nginx
systemctl enable nginx

# Start php-fpm
systemctl start php-fpm
systemctl enable php-fpm
