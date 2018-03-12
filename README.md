## Dokumentasi Tugas

#### 1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'.

**Jawab** :

#### 2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework

**Jawab** :

```bash
#!/usr/bin/env bash
#this is how to install phoenix web framework by using shell script

#update and install elixir
sudo apt-get update
sudo apt-get install -y elixir

#use mix to install hex
mix local.hex

#download and add the Erlang Repository to server
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

#update and install Erlang
sudo apt-get update
sudo apt-get install -y esl-erlang

#install Phoenix archive
echo y | mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

#make project directory
mkdir phoenix
sudo mix phx.new --no-ecto --no-brunch phoenix

#run server
cd phoenix
sudo mix phx.server
	
```


#### 3. Buat vagrant virtualbox dan lakukan provisioning install:

- php
- mysql
- composer
- nginx

    setelah melakukan provioning, clone https://github.com/fathoniadi/pelatihan-laravel.git pada folder yang sama dengan vagrantfile di komputer host. Setelah itu sinkronisasi folder pelatihan-laravel host ke vagrant ke /var/www/web dan jangan lupa install vendor laravel agar dapat dijalankan. Setelah itu setting root document nginx ke /var/www/web. webserver VM harus dapat diakses pada port 8080 komputer host dan mysql pada vm dapat diakses pada port 6969 komputer host.

**Jawab** :

#### 4. Buat vagrant virtualbox dan lakukan provisioning install:

- Squid proxy
- Bind9

**Jawab** :

```bash
#!/usr/bin/env bash
#this is how to install squid3 and bind9

sudo apt-get update
sudo apt-get install -y squid3
sudo apt-get install -y bind9
```

