#!/usr/bin/env bash

# 1.
# this is how to create user
sudo useradd awan
echo -e "buayakecil\nbuayakecil" | sudo passwd awan

# 2.
#this is how to install phoenix web framework by using shell script

#download and add the Erlang Repository to server
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

#update and install Erlang
sudo apt-get update
sudo apt-get install -y esl-erlang

#update and install elixir
sudo apt-get install elixir

#use mix to install hex
echo y | mix local.hex

#install Phoenix archive
echo y | mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

#make project directory
mkdir newproject
echo y | sudo mix phx.new --no-ecto --no-brunch newproject

#run server
cd newproject
echo y | sudo mix deps.get
echo y | sudo mix phx.server
# 3.

# this is how to install php
sudo apt-get -y update
sudo apt-get install -y software-properties-common build-essential
sudo add-apt-repository ppa:ondrej/php
sudo apt-get -y update
sudo apt-get install -y php7.1 php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-zip php7.1-fpm

# this is how to install mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
sudo apt-get -y update
apt-get install -y mysql-server
apt-get install -y mysql-client

# this is how to install php
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# this is how to install nginx
sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start

# 4.
# this is how to install squid3 and bind9
sudo apt-get -y update
sudo apt-get install -y squid3
sudo apt-get install -y bind9