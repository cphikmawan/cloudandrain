## Dokumentasi Tugas

## Created By Cloud and Dr. Fu

### Kebutuhan
- Virtual Box
- Vagrant
- VM Box Ubuntu 16.04 Xenial 64bit 

### SOAL

Buatlah sistem load balancing dengan 1 load balancer(nginx dan 2 worker(apache2), terapkan algoritma load balancing round-robin, least-connected, dan ip-hash.

Soal :

1. Buatlah Vagrantfile sekaligus provisioning-nya untuk menyelesaikan kasus.
2. Analisa apa perbedaan antara ketiga algoritma tersebut.
3. Biasanya pada saat membuat website, data user yang sedang login disimpan pada session. Sesision secara default tersimpan pada memory pada sebuah host. Bagaimana cara mengatasi masalah session ketika kita melakukan load balancing?


### 1. Membuat Vagrantfile sekaligus provisioning-nya 

#### Membuat VM Ubuntu 16.04 Xenial
1. Download box xenial

	 	wget https://vagrantcloud.com/ubuntu/boxes/xenial64/versions/20180309.0.0/providers/virtualbox.box

2. Addbox dengan cara

	**vagrant box add (nama_box_terserah) (box_hasil_download)**

		vagrant box add ubuntu/xenial64 xenial-server-cloudimg-amd64-vagrant.box

3. Edit Box, kemudian `vagrant up`

		config.vm.box = "ubuntu/xenial64"

#### Edit Vagrantfile
1. Aktifkan private networking pada setiap Vagrantfile

		config.vm.network "private_network", ip: "xxx.xxx.xxx.xxx"

		##### Loadbalancer (192.168.33.10) | Worker 1 (192.168.33.11) | Worker 2 (192.168.33.12)

2. Aktifkan Provisioning

		config.vm.provision :shell, path: "bootstrap.sh" 

#### Buat File Provisioning (bootstrap.sh)
1. Load balancer 
	
		sudo apt-get update
		sudo apt-get install -y php7.0 php7.0-fpm php7.0-cgi nginx

2. Worker 1 dan 2
	
		sudo apt-get update
		sudo apt-get install -y php7.0 php7.0-fpm libapache2-mod-php apache2

#### Edit file config Nginx pada Load Balancer

		etc/nginx/sites-available/default

1. Tambahkan upstream (pilih salah satu)
		
		#### mode Round Robin

		upstream lb {
			server 192.168.33.11:9000;
			server 192.168.33.12:9000;
		}

		#### mode Least Connection

		upstream lb {
			least_conn;
			server 192.168.33.11:9000;
			server 192.168.33.12:9000;
		}

		#### mode IP Hash

		upstream lb {
			ip_hash;
			server 192.168.33.11:9000;
			server 192.168.33.12:9000;
		}

2. Edit config php 
		
		# Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;

        # pass the PHP scripts to FastCGI server listening on "lb"
		location ~ \.php$ {
               include snippets/fastcgi-php.conf;
               fastcgi_pass lb;
        }

3. Restart Nginx
		
		sudo service nginx restart

#### Edit file config PHP-fpm pada Worker 1 dan 2

		/etc/php/7.0/fpm/pool.d/www.conf

1. Ubah variabel listen
		
		dari :
			listen = /run/php/php7.0-fpm.sock
		
		menjadi :
			listen = 9000

2. Restart PHP-fpm

		sudo service php7.0-fpm restart

#### Buat file PHP di masing masing Load balancer dan Worker

		/var/www/html/index.php

#### Test menggunakan browser dengan membuka alamat ip dari load balancer

### 2. Perbedaan Algoritma IP Hash, Round Robin, dan Least Connection

#### Round Robin
Tipe Load Balancing ini akan mendistribusikan Traffic ke server-server dibelakangnya dengan sama rata. Tipe ini cocok untuk melayani Website dengan tipe statik dikarenakan cara kerjanya yang mendistribusikan Traffic ke Semua Server. Meskipun memungkinkan untuk diaplikasikan pada Website Dinamis namun harus melakukan konfigurasi lebih lanjut karena jika tidak maka akan memiliki masalah pada Sesi Aplikasi.

#### Least Connection
Tipe Load Balancing ini akan mendistribusikan Traffic ke Server yang mempunyai beban load yang rendah. Karakteristik dari Tipe ini sama seperti Round Robin, yaitu cocok untuk Website Statik namun akan bermasalah untuk Website Dinamis apabila tidak ada konfigurasi lanjut.

#### IP Hash
Tipe Load Balancing ini akan mendistribusikan Traffic berdasarkan IP dari Client. NGINX akan mencocokkan Webserver Backend dengan IP yang dimiliki oleh Client, sehingga apabila seorang Client mendapatkan jawaban dari Server A pada pertama kali, maka request selanjutnya juga akan mendapat jawaban dari Server A dan seterusnya sampai Server tersebut dianggap Down, jika Down maka Client baru akan diarahkan ke Server B dan seterusnya. Karena itu dari ketiga tipe Load Balancing ini, IP Hash adalah tipe yang paling cocok diaplikasikan pada Website Dinamis.

### 3. Cara mengatasi masalah session ketika kita melakukan load balancing

Ada konfigurasi yang namanya sticky session. Jika menggunakan konfigurasi ini, pada hit pertama si user akan diberikan penanda, biasanya berbentuk cookie. Pada hit berikutnya, LB akan melihat cookienya, dan mengarahkan ke server yang sebelumnya sudah mengurus si user ini. 

## Selesai

- Cahya Putra Hikmawan (Cloud) - 05111540000119
- Fuad Dary Rosyadi (Dr. Fu) - 05111540000089
