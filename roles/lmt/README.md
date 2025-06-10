## Trying to install LMT

$ dnf install -y cargo

$ dnf install rust-sqlx-postgres-devel

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


