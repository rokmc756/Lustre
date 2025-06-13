## Trying to install LMT

$ dnf install -y cargo

$ dnf install rust-sqlx-postgres-devel rust-openssl-sys-devel

$ git clone https://github.com/whamcloud/integrated-manager-for-lustre/

$ cd integrated-manager-for-lustre

$ vi cat .env
DATABASE_URL=postgres://jomoon@192.168.2.201:5432/pgsql_testdb

$ mkdir ~/cargo-target
$ echo 'export CARGO_TARGET_DIR=~/cargo-target' >> ~/.bashrc
$ source ~/.bashrc

$ cargo install sqlx-cli



## References
- https://github.com/whamcloud/integrated-manager-for-lustre/
- https://github.com/chaos/lmt-gui
- https://github.com/LLNL/lmt
- https://wiki.lustre.org/Integrated_Manager_for_Lustre
- https://docs.rs/crate/sqlx-cli/latest
- https://copr.fedorainfracloud.org/coprs/managerforlustre/manager-for-lustre-6.3/
- https://blog.naver.com/kmk1030/220712037849
- https://github.com/lmenezes/cerebro/releases/tag/v0.9.4
- https://support.hpe.com/hpesc/public/docDisplay?docId=a00113982en_us&page=Configure_the_LMT_GUI.html
- https://collectl.sourceforge.net/
- https://github.com/jhammond/lltop
- https://github.com/LLNL/lmt/wiki/Installation
- https://github.com/jhammond/tacc_stats


## Install on Centos 7

$ sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
$ sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

$ yum clean all
$ yum repolist

$ vi /etc/yum.repos.d/chroma_support.repo
$ yum install yum-utils
$ dnf install postgresql96-contrib postgresql96-server rpmlib grafana-12.0.1
$ yum install -y python2-iml-manager

$ chroma-config setup
Starting setup...

Starting InfluxDB...
Creating InfluxDB database...
Setting up PostgreSQL service...
Insufficient space for postgres database in path directory /var/lib/pgsql/9.6/data. 46GB available, 100GB required
Errors found:
  * Insufficient space for postgres database in path directory /var/lib/pgsql/9.6/data. 46GB available, 100GB required
.....




$ chroma-config setup
Starting setup...

Starting InfluxDB...
Creating InfluxDB database...
Setting up PostgreSQL service...
Creating database owner 'chroma'...

Creating database 'chroma'...

Enabling database extensions...
Creating database tables...
Creating groups...


Loaded 13 default power device types.
Registering repo: /usr/share/chroma-manager/base.repo
Registering repo: /usr/share/chroma-manager/chroma_support.repo
Registering repo: /usr/share/chroma-manager/lustre-client-mlnx.repo
Registering repo: /usr/share/chroma-manager/lustre-client.repo
Registering repo: /usr/share/chroma-manager/lustre-server-mlnx.repo
Registering repo: /usr/share/chroma-manager/lustre-server-patchless.repo
Registering repo: /usr/share/chroma-manager/lustre-server.repo
Registering profile: /usr/share/chroma-manager/base_managed_RH7.profile
Registering profile: /usr/share/chroma-manager/base_managed_ib_RH7.profile
Registering profile: /usr/share/chroma-manager/base_managed_patchless.profile
Registering profile: /usr/share/chroma-manager/base_monitored.profile
Registering profile: /usr/share/chroma-manager/default.profile
Registering profile: /usr/share/chroma-manager/default_baseless.profile
Registering profile: /usr/share/chroma-manager/posix_copytool_worker.profile
Registering profile: /usr/share/chroma-manager/posix_copytool_worker_mlnx.profile
Registering profile: /usr/share/chroma-manager/robinhood_server.profile
Registering profile: /usr/share/chroma-manager/robinhood_server_mlnx.profile
An administrative user account will now be created using the credentials which you provide.
Username:
A value is required
Username:
A value is required
Username: jomoon
Password:
Confirm password:
Email: rokmc756@gmail.com
User 'jomoon' successfully created.
API user created
NTP Server [localhost]:
Writing ntp configuration: localhost
Disabling chrony if active
Restarting ntp
Starting RabbitMQ...
Creating RabbitMQ user...
Creating RabbitMQ vhost...

