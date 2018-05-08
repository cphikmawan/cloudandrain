# Dokumentasi Konfigurasi Haproxy Load Balancer dengan ansible

Untuk melakukan konfigurasi haproxy menggunakan ansible terlebih dahulu menyiapkan 2 server.

  - Komputer pengontrol (bisa komputer desktop,laptop,dll)
  - Server Load Balancer (komputer server yang digunakan sebagai load balancer)

## Langkah-langkah instalasi
Instalasi akan dilakukan pada komputer pengontrol dan komputer server

### Instalasi Komputer Pengontrol
Komputer pengontrol adalah komputer/laptop yang digunakan untuk mengkonfigurasi komputer server. Komputer pengontrol adalah komputer/laptop dengan sistem operasi berbasis linux.

Paket-paket yang harus terinstall pada komputer pengontrol adalah:
 - [ansible] - Ansible adalah salah satu tools Configuration Management
 - ssh - ssh adalah secure shell, digunakan untuk melakukan remote koneksi ke komputer server secara aman

#### Install Ansible
##### Install ansible pada platform Red Hat/Fedora.
Untuk instalasi menggunakan yum cukup menjalankan
```
$ sudo yum install ansible
```
Untuk instalasi melalui kode sumber bisa menjalankan perintah.
```
$ git clone git://github.com/ansible/ansible.git --recursive
$ cd ./ansible
$ make rpm
$ sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm
```
##### Install ansible pada platform Ubuntu.
Pada ubuntu versi 16.04 cukup menjalankan
```
$ sudo apt-get install ansible
```
Jika paket tidak ditemukan maka perlu menambahkan repository dari ppa.
```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```
##### Install ansible pad Mac OS X
jika telah terinstall [Homebrew] 
```
> brew install ansible
```
Jika menggunakan pip
```
sudo easy_install pip
sudo pip install ansible --quiet
sudo pip install ansible --upgrade
```

### Instalasi Komputer Server
Install openssh-server
```
$ sudo apt-get install openssh-server
```
Pastikan python 2.7 terinstall.
```
$ sudo apt-get install python2.7
```

## Konfigurasi Ansible
Sebelum menjalankan ansible playbook beberapa pengaturan harus di sesuaikan terlebih dahulu
### Konfigurasi inventory ansible
edit file production, pada baris:
```
# production inventory

[lb]
lb1			ansible_host=10.151.38.181	ansible_user=thiar
```
ubah ***ansible_host*** pada **lb1** menjadi alamat ip pada komputer server dan ***ansible_user*** menjadi user yang digunakan untuk login pada komputer server. 

### Konfigurasi haproxy http load balancer
Pada file **lb.yml** silahkan ubah parameter berikut
```
haproxy_app_name: myapp
haproxy_mode: http
haproxy_app_port: 8080
```
- **haproxy_app_name** nama dari aplikasi haproxy yang digunakan. Nama bisa diisi sembarang nama.
- **haproxy_mode** karena aplikasi haproxy yang digunakan sebagai http load balancer maka harus diisi dengan http.
- **haproxy_app_port** nomor port dari aplikasi haproxy yang akan digunakan. port ini yang akan diakses user sebelum nantinya akan di lakukan pembagian beban ke layanan sesungguhnya.

### Konfigurasi daftar worker
Pada file **lb.yml** , tuliskan daftar worker yang digunakan pada sistem.
pada baris tersebut tuliskan daftar komputer yang digunakan sebagai worker.
```
    haproxy_backend_servers:
      - {name: server1, ip: 10.151.36.80, port: 80, paramstring: cookie A check}
      - {name: server2, ip: 10.151.36.81, port: 80, paramstring: cookie A check}
```

- **name** bisa diisi dengan sembarang nama, asal tidak sama antar komputer. 
- **ip** diisi dengan alamat ip dari masing-masing komputer worker.
- **paramstring** biarkan tetap **cookie A check** 

### Konfigurasi statistik haproxy
Untuk melihat statistik kinerja dari haproxy maka beberapa parameter harus di tentukan. pada file **lb.yml** kita tentukan parameter-parameter yang dibutuhkan.
Pada baris 
```
haproxy_enable_stats: enable
haproxy_stats_port: 1932 
```
- **haproxy_enable_stats** di set *enable* untuk mengaktifkan statistik dan *disable* untuk menonaktifkan statistik.
- **haproxy_stats_port** adalah nomor port yang digunakan untuk mengakses halaman statistik.

Menentukan user yang diperbolehkan untuk mengakses statistik, pada baris
```
haproxy_stats_users:
      - {username: thiar, password: kucinglucu}
```
- **username** adalah username yang digunakan untuk mengakses halaman statistik
- **password** adalah password yang digunakan untuk mengakses halaman statistik

### Menentukan algoritma Load Balancing
Pada file **lb.yml**, pada baris
```
haproxy_algorithm: roundrobin
```
**haproxy_algorithm** dapat diganti dengan algoritma lain sesuai kebutuhan. Daftar algoritma berdasarkan penjelasannya dapat dilihat di [algorithm].

## Menjalankan ansible playbook
Setelah melakukan konfigurasi diatas. Pertama-tama pastikan komputer server yang akan di setting dapat di akses menggunakan ssh.
```
ssh thiar@10.151.38.181
```
Ganti **thiar** dengan nama user anda dan **10.151.38.181** dengan alamat ip anda. Pastikan user anda memiliki hak akses *root*.
Jalankan Playbook menggunakan perintah:
```
ansible-playbook -i production master.yml -k --ask-sudo-pass
```
Ketika diminta **password** untuk akses ssh, ketikkan password anda.
```
~/ansible-best-practice$ ansible-playbook -i production master.yml -k --ask-sudo-pass
SSH password:
```
setelah itu akan diminta password untuk login sebagai user root. Jika paswword ssh dan password user anda sama maka cukup menekan ***Enter***.
```
SSH password: 
SUDO password[defaults to SSH password]:
```
Kemudian tunggulah ansible melakukan konfigurasi terhadap server anda
```
PLAY [lb] *************************************************************

TASK [setup] **********************************************************
ok: [lb1]
TASK [haproxy : install on debian based linux] ************************
changed: [lb1] => (item=[u'haproxy'])

TASK [haproxy : Enable init script] ***********************************
ok: [lb1]

TASK [haproxy : Update HAProxy config] ********************************
changed: [lb1]

RUNNING HANDLER [haproxy : restart haproxy] ***************************
changed: [lb1]

PLAY RECAP ************************************************************
lb1             : ok=5    changed=3    unreachable=0    failed=0  
```
Konfigurasi selesai.

Untuk melihat apakah service telah berjalan dengan cara login ke komputer server, kemudian jalankan perintah. 
```
sudo service haproxy status
```

Untuk mengakses service haproxy bisa menggunakan **ip_server:haproxy_app_port** pada browser (jika port yang digunakan 80, maka tidak perlu mencantumkan port pada saat mengakses).
Sedangkan untuk mengakses statistik haproxy bisa menggunakan **ip_server:haproxy_stats_port** pada browser.


[ansible]: <http://www.ansible.com>
[Homebrew]: <http://brew.sh/>
[algorithm]: <https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4-balance>