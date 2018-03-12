## Dokumentasi Tugas

#### 1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'.

**Jawab** :

#### 2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework

**Jawab** :

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
	sudo apt-get update
	sudo apt-get install -y squid3
	sudo apt-get install -y bind9
```

