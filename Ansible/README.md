## Tugas Ansible

### Anggota Kelompok :

##### 1. Fuad Dary Rosyadi (Dr. Fu) - 05111540000089   
##### 2. Cahya Putra Hikmawan (Cloud) - 05111540000119

### Penyelesaian Tugas Ansible

- ##### ***Deploy Laravel Using Ansible With 3 Virtual Machine (1 DB Server and 2 Workers)***
- ##### ***OS DB Server : Debian 9***
- ##### ***OS Workers : Ubuntu-Server 16.04***

#### 1. Deployment
1. Mempersiapkan workers debian dan ubuntu. deployment kali ini menggunakan virtual box, VDI bisa download di [osboxes.org](http://osboxes.org "osboxes")
2. Setting VM
- Pastikan sudah terinstall ssh, jika belum install terlebih dahulu
```
    sudo apt-get install openssh-server
```
- (Optional) Edit file sshd_conf dan uncomment(jika belum) pada baris-baris berikut
```
    PermitRootLogin yes
    RSAAuthentication yes
```
- Pastikan semua VM sudah dapat di remote menggunakan SSH karena **Ansible** terkoneksi menggunakan SSH


3. Install Ansible di host yang akan digunakan untuk remote akses menggunakan ansible
```
    sudo apt install ansible
    sudo apt-get install sshpass
```

4. Run Ansible dengan perintah berikut
```
    ansible-playbook -i hosts cloud.yml -k
```
![Run Test](assets/ansible-playbook.png "Run Test")

5. Hollaa!!!
- **Worker 1**


![Dashboard](assets/dashboard.png "Dashboard")

![Login](assets/login.png "Login")

![Register](assets/register.png "Register")

- **Worker 2**


![Dashboard](assets/dashboard2.png "Dashboard")

![Login](assets/login2.png "Login")

![Register](assets/register2.png "Register")


#### 2. Cara Kerja & Penjelasan
- ##### File cloud.yml

    File **cloud.yml** adalah file utama dalam playbook yang akan digunakan yang mengatur seluruh instalasi atau setting pada VM yang di remote.
    - **hosts** mendefinisikan group yang terdapat pada file hosts
    - **vars** mendefinisikan variable
    - **roles** mendefinisikan roles yang terdapat pada direktori roles untuk tiap hosts akan dijalankan role playbook yang mana
    ```
    ---
    # roles role

    - hosts: db
      vars:
        proxy_env: 'http://ITS-553468-dc885:0e820@proxy.its.ac.id:8080'
        username: 'regal'
        password: 'bolaubi'
      roles:
        - { role: db }

    - hosts: worker
      vars:
        proxy_env: 'http://ITS-553468-dc885:0e820@proxy.its.ac.id:8080'
      roles:
        - { role: worker }
    ```

- ##### File hosts
    Berisi host yang akan diremote (VM) yaitu DB dan Workers
    ```
    [db]
    db ansible_host=10.151.36.197 ansible_user=root ansible_become_pass=sembarang

    [worker]
    worker1 ansible_host=10.151.36.198 ansible_user=root ansible_become_pass=sembarang
    worker2 ansible_host=10.151.36.199 ansible_user=root ansible_become_pass=sembarang
    ```

- ##### Roles
  - Roles yang digunakan adalah DB dan Worker
  - Pada setiap roles di handlers dan worker terdapat file **mail.yml**, file tersebut yang akan dibaca oleh ansible-playbook
  - Pada masing-masing roles terdapat direktori
    - handlers
      berisikan role untuk restart terhadap aplikasi yang memerlukan service restart, pada DB digunakan untuk restart **mysql** dan pada Workers untuk restart **nginx**

    - tasks - file **main.yml**
      ansible-playbook otomatis akan menjalankan main.yml pada tiap roles (keterangan ini sudah ada di atas)

      1. main.yml pada db
      ```
      ---
      name: delete apt chache
      become: yes
      become_user: root
      become_method: su
      command: rm -vf /var/lib/apt/lists/*

      name: install on debian based linux
      become: yes
      become_user: root
      become_method: su
      environment: 
        http_proxy: "{{ proxy_env }}"
        https_proxy: "{{ proxy_env }}"
      apt: name={{ item }} state=latest update_cache=true
      with_items:
      - mysql-server
      - python-mysqldb
      when: ansible_os_family  == "Debian"

      name: Create user for mysql
      mysql_user: user={{username}} host="%" password={{password}} priv=*.*:ALL,GRANT
      
      name: Create DB
      mysql_db: name=hackathon state=present collation=utf8_general_ci


      name: Copy .my.cnf file with root password credentials
      template: 
        src=templates/my.cnf 
        dest=/etc/mysql/mariadb.conf.d/50-server.cnf
      notify: restart mysql
      ```

      2. main.yml pada worker - include bermaksud untuk memanggil tiap file YAML
      ```
      ---
      include : preinstall.yml
      include : install.yml
      include : clone.yml
      include : postinstall.yml
      include : nginx.yml
      ``` 

    - templates
      Berisikan file configurasi untuk mysql(my.cnf), nginx(default) dan env

#### Referensi
[1. http://www.ansible.com](http://www.ansible.com "ansible")

[2. Modul Ansible -  Cloud Computing](https://github.com/fathoniadi/cloud-2018/tree/master/ansible "Modul")

[3. Buku Anak TC](https://stackoverflow.com/ "stackoverflow")