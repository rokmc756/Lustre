### What is Lustre?
Lustre* is an open-source, global single-namespace, POSIX-compliant, distributed parallel file system designed for scalability, high-performance, and high-availability.

Lustre runs on Linux-based operating systems and employs a client-server network architecture. Storage is provided by a set of servers that can scale to populations measuring up to several hundred hosts.

Lustre servers for a single file system instance can, in aggregate, present up to hundreds of petabytes of storage to thousands of compute clients, with multiple terabytes per second of combined throughput.

Lustre is a file system that scales to meet the requirements of applications running on a range of systems from small-scale HPC environments up to the very largest supercomputers and has been created using object-based storage building blocks to maximize scalability.

Redundant servers support storage fail-over, while metadata and data are stored on separate servers, allowing each file system to be optimized for different workloads.

Lustre can deliver fast IO to applications across high-speed network fabrics, such as Ethernet, InfiniBand (IB), Omni-Path (OPA), and others.

### Lustre Filesystem Architecture
<p align="center">
<img src="https://github.com/rokmc756/Lustre/blob/main/roles/lustre/images/lustre_file_system_overview_dne_lowres_v1.png" width="70%" height="70%">
</p>

### Lustre Ansible Playbook
This Ansible Playbook provides the feature to build a Lustre Filesystem on Baremetal, Virtual Machines.
The main purposes of this project are simple to deploy Lustre Filesystem quickly and learn knowleges about it.
If you're unfamiliar with Lustre, please refer to the
[Introduction to Lustre](https://wiki.lustre.org/Introduction_to_Lustre) of the Lustre user's guide to learn more.

**`System requirements`**:
  - All target systems must have passwordless SSH access.
  - All hostnames used in the inventory file are resolvable (or use IP addresses).
  - MacOS or Linux(or WSL) should have installed ansible as Ansible Host.
  - At least a Normal User which has Sudo Privileges


### Prepare ansible host to run this playbook
* MacOS
```sh
xcode-select --install
brew install ansible
brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

### Where is it originated?
It has been developing based on the following project - https://github.com/stackhpc/ansible-lustre/tree/master/ansible
Since above project is not useful to me, I modified it with make utility.


### Verified Lustre Version
* Lustre 2.16.x


### Supported Platform and OS
* Virtual Machines
* Baremetal
* Rocky Linux 9.4


### How to deply Lustre Cluster by This Ansible Playbook
#### 1) Configure Ansible Hosts
Add the target system information into the inventory file named `ansible-hosts`.
For example:
```ini
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[iscsi]
rk94-node00 ansible_ssh_host=192.168.2.248 ansible_ssh_host1=192.168.0.248
rk94-node99 ansible_ssh_host=192.168.2.249 ansible_ssh_host1=192.168.0.249

[mgs]
rk94-node01 ansible_ssh_host=192.168.2.201

[mds]
rk94-node02 ansible_ssh_host=192.168.2.202

[dne]
rk94-node03 ansible_ssh_host=192.168.2.203
rk94-node04 ansible_ssh_host=192.168.2.204

[oss]
rk94-node05 ansible_ssh_host=192.168.2.205
rk94-node06 ansible_ssh_host=192.168.2.206
rk94-node07 ansible_ssh_host=192.168.2.207
rk94-node08 ansible_ssh_host=192.168.2.208

[cluster:children]
mgs
mds
dne
oss

[client]
rk94-node09 ansible_ssh_host=192.168.2.209
rk94-node10 ansible_ssh_host=192.168.2.210
~~ snip
```

#### 2) Configure Global Variables
```yaml
$ vi group_vars/all.yaml
---
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"

_lustre:
  project_name: lustre
  os_version: "el9"
  os_minor_version: "4"
  domain: "jtest.ddn.com"
  rdomain: "com.ddn.jtest"
  cluster_name: jack-kr-lustre
  major_version: "2"
  minor_version: "16"
  patch_version: "0"
  build_version: "0"
  download_url: "https://downloads.whamcloud.com/public/lustre"
  download: false
  base_path: /root
  admin_user: admin
  admin_passwd: changeme
  bin_type: tar
  nvme: true
  net:
    conn: "dpdk"                     # dpdk or udp
    gateway: "192.168.2.1"
    ha1: 1
    ha2: 2
    type: "virtual"                  # or physical
    ipaddr0: "192.168.0.2"
    ipaddr1: "192.168.1.2"
    ipaddr2: "192.168.2.2"
~~ snip
```

When ready, run the make commands
#### 3) Prepare Linux Hosts to install packages required and generate/exchange ssh keys among all hosts.
Initialize Hosts
```sh
make hosts r=init s=all

```
Uninitialize Hosts
```sh
make hosts r=uninit s=all
```

#### 4) Configure Global Variables for iSCSI to deploy Lustre Storage with DNE ( Distributed Namespace )
```yaml
---
_iscsi:
  target:
    iqn01: "iqn.2025-04.com.ddn.jtest01"
    iqn02: "iqn.2025-04.com.ddn.jtest02"
    user: "iscsiadm"
    password: "changeme"
    os_version: "rk9"
    disks:
      - { name: "jtest-vdisk011", base_dir: "/vdisk/iscsi01", size: "10G", group: "dt1", mp_alias: "mgt11", iscsi_dev: "sda", client: "rk94-node01" }
      - { name: "jtest-vdisk012", base_dir: "/vdisk/iscsi01", size: "10G", group: "dt1", mp_alias: "mgt12", iscsi_dev: "sdb", client: "rk94-node01" }
      - { name: "jtest-vdisk021", base_dir: "/vdisk/iscsi02", size: "10G", group: "dt1", mp_alias: "mdt11", iscsi_dev: "sda", client: "rk94-node02" }
      - { name: "jtest-vdisk022", base_dir: "/vdisk/iscsi02", size: "10G", group: "dt1", mp_alias: "mdt12", iscsi_dev: "sdb", client: "rk94-node02" }
      - { name: "jtest-vdisk031", base_dir: "/vdisk/iscsi03", size: "10G", group: "dt2", mp_alias: "mdt21", iscsi_dev: "sda", client: "rk94-node03" }
      - { name: "jtest-vdisk032", base_dir: "/vdisk/iscsi03", size: "10G", group: "dt2", mp_alias: "mdt22", iscsi_dev: "sdb", client: "rk94-node03" }
      - { name: "jtest-vdisk041", base_dir: "/vdisk/iscsi04", size: "10G", group: "dt2", mp_alias: "mdt31", iscsi_dev: "sda", client: "rk94-node04" }
      - { name: "jtest-vdisk042", base_dir: "/vdisk/iscsi04", size: "10G", group: "dt2", mp_alias: "mdt32", iscsi_dev: "sdb", client: "rk94-node04" }
      - { name: "jtest-vdisk051", base_dir: "/vdisk/iscsi05", size: "10G", group: "dt3", mp_alias: "ost11", iscsi_dev: "sda", client: "rk94-node05" }
      - { name: "jtest-vdisk052", base_dir: "/vdisk/iscsi05", size: "10G", group: "dt3", mp_alias: "ost12", iscsi_dev: "sdb", client: "rk94-node05" }
      - { name: "jtest-vdisk061", base_dir: "/vdisk/iscsi06", size: "10G", group: "dt3", mp_alias: "ost21", iscsi_dev: "sda", client: "rk94-node06" }
      - { name: "jtest-vdisk062", base_dir: "/vdisk/iscsi06", size: "10G", group: "dt3", mp_alias: "ost22", iscsi_dev: "sdb", client: "rk94-node06" }
      - { name: "jtest-vdisk071", base_dir: "/vdisk/iscsi07", size: "10G", group: "dt4", mp_alias: "ost31", iscsi_dev: "sda", client: "rk94-node07" }
      - { name: "jtest-vdisk072", base_dir: "/vdisk/iscsi07", size: "10G", group: "dt4", mp_alias: "ost32", iscsi_dev: "sdb", client: "rk94-node07" }
      - { name: "jtest-vdisk081", base_dir: "/vdisk/iscsi08", size: "10G", group: "dt4", mp_alias: "ost41", iscsi_dev: "sda", client: "rk94-node08" }
      - { name: "jtest-vdisk082", base_dir: "/vdisk/iscsi08", size: "10G", group: "dt4", mp_alias: "ost42", iscsi_dev: "sdb", client: "rk94-node08" }
    clients:
      - { name: "jtest-vdisk011", base_dir: "/vdisk/iscsi01", size: "10G", group: "dt1", mp_alias: "dt111", iscsi_dev: "sda", client: "rk94-node01" }
      - { name: "jtest-vdisk021", base_dir: "/vdisk/iscsi02", size: "10G", group: "dt1", mp_alias: "dt121", iscsi_dev: "sda", client: "rk94-node02" }
      - { name: "jtest-vdisk012", base_dir: "/vdisk/iscsi01", size: "10G", group: "dt1", mp_alias: "dt112", iscsi_dev: "sdb", client: "rk94-node01" }
      - { name: "jtest-vdisk022", base_dir: "/vdisk/iscsi02", size: "10G", group: "dt1", mp_alias: "dt122", iscsi_dev: "sdb", client: "rk94-node02" }
      - { name: "jtest-vdisk031", base_dir: "/vdisk/iscsi03", size: "10G", group: "dt2", mp_alias: "dt211", iscsi_dev: "sda", client: "rk94-node03" }
      - { name: "jtest-vdisk041", base_dir: "/vdisk/iscsi04", size: "10G", group: "dt2", mp_alias: "dt221", iscsi_dev: "sda", client: "rk94-node04" }
      - { name: "jtest-vdisk032", base_dir: "/vdisk/iscsi03", size: "10G", group: "dt2", mp_alias: "dt212", iscsi_dev: "sdb", client: "rk94-node03" }
      - { name: "jtest-vdisk042", base_dir: "/vdisk/iscsi04", size: "10G", group: "dt2", mp_alias: "dt222", iscsi_dev: "sdb", client: "rk94-node04" }
      - { name: "jtest-vdisk051", base_dir: "/vdisk/iscsi05", size: "10G", group: "dt3", mp_alias: "dt311", iscsi_dev: "sda", client: "rk94-node05" }
      - { name: "jtest-vdisk061", base_dir: "/vdisk/iscsi06", size: "10G", group: "dt3", mp_alias: "dt321", iscsi_dev: "sda", client: "rk94-node06" }
      - { name: "jtest-vdisk052", base_dir: "/vdisk/iscsi05", size: "10G", group: "dt3", mp_alias: "dt312", iscsi_dev: "sdb", client: "rk94-node05" }
      - { name: "jtest-vdisk062", base_dir: "/vdisk/iscsi06", size: "10G", group: "dt3", mp_alias: "dt322", iscsi_dev: "sdb", client: "rk94-node06" }
      - { name: "jtest-vdisk071", base_dir: "/vdisk/iscsi07", size: "10G", group: "dt4", mp_alias: "dt411", iscsi_dev: "sda", client: "rk94-node07" }
      - { name: "jtest-vdisk081", base_dir: "/vdisk/iscsi08", size: "10G", group: "dt4", mp_alias: "dt421", iscsi_dev: "sda", client: "rk94-node08" }
      - { name: "jtest-vdisk072", base_dir: "/vdisk/iscsi07", size: "10G", group: "dt4", mp_alias: "dt412", iscsi_dev: "sdb", client: "rk94-node07" }
      - { name: "jtest-vdisk082", base_dir: "/vdisk/iscsi08", size: "10G", group: "dt4", mp_alias: "dt422", iscsi_dev: "sdb", client: "rk94-node08" }
```

#### 5) Create iSCSI Target and Initiator with Multipath to simulate SAN or JBOD Storage
```sh
make iscsi r=create s=target
make iscsi r=create s=initiator
make iscsi r=enable s=multipath

or
make iscsi r=install s=all
```

#### 6) Delete iSCSI Target and Initiator with Multipath to simulate SAN or JBOD Storage
```sh
make iscsi r=disable s=multipath
make iscsi r=delete s=initiator
make iscsi r=delete s=target

or
make iscsi r=uninstall s=all
```

#### 7) Configure Global Variables for Lustre to deploy Lustre Storage with DNE ( Distributed Namespace )
```yaml
---
_cluster:
  lnet:
    - { suffix: "@tcp2", net2: "{{ hostvars[groups['client'][0]]['ansible_ssh_host'] }}@tcp2" }
  mgs:
    - { dev_prefix: "/dev/mapper", dev: "dt111", phy_dev: "sda", mnt_dir: "/lustre/mgs0", idx_id: "0", fs: "tfs1", node: "rk94-node01" }
  mdts:
    - { dev_prefix: "/dev/mapper", dev: "dt121", phy_dev: "sda", idx_id: "1",  fs: "tfs1", lnet_suffix: "@tcp2", node: "rk94-node02" }
    - { dev_prefix: "/dev/mapper", dev: "dt122", phy_dev: "sdb", idx_id: "0",  fs: "tfs2", lnet_suffix: "@tcp2", node: "rk94-node02" }
    - { dev_prefix: "/dev/mapper", dev: "dt211", phy_dev: "sda", idx_id: "2",  fs: "tfs1", lnet_suffix: "@tcp2", node: "rk94-node03" }
    - { dev_prefix: "/dev/mapper", dev: "dt212", phy_dev: "sdb", idx_id: "0",  fs: "tfs3", lnet_suffix: "@tcp2", node: "rk94-node03" }
    - { dev_prefix: "/dev/mapper", dev: "dt221", phy_dev: "sda", idx_id: "1",  fs: "tfs2", lnet_suffix: "@tcp2", node: "rk94-node04" }
    - { dev_prefix: "/dev/mapper", dev: "dt222", phy_dev: "sdb", idx_id: "1",  fs: "tfs3", lnet_suffix: "@tcp2", node: "rk94-node04" }
  osts:
    - { dev_prefix: "/dev/mapper", dev: "dt311", phy_dev: "sda", idx_id: "3",  fs: "tfs1", lnet_suffix: "@tcp2", node: "rk94-node05" }
    - { dev_prefix: "/dev/mapper", dev: "dt312", phy_dev: "sdb", idx_id: "3",  fs: "tfs2", lnet_suffix: "@tcp2", node: "rk94-node05" }
    - { dev_prefix: "/dev/mapper", dev: "dt321", phy_dev: "sda", idx_id: "2",  fs: "tfs3", lnet_suffix: "@tcp2", node: "rk94-node06" }
    - { dev_prefix: "/dev/mapper", dev: "dt322", phy_dev: "sdb", idx_id: "4",  fs: "tfs1", lnet_suffix: "@tcp2", node: "rk94-node06" }
    - { dev_prefix: "/dev/mapper", dev: "dt411", phy_dev: "sda", idx_id: "4",  fs: "tfs2", lnet_suffix: "@tcp2", node: "rk94-node07" }
    - { dev_prefix: "/dev/mapper", dev: "dt412", phy_dev: "sdb", idx_id: "3",  fs: "tfs3", lnet_suffix: "@tcp2", node: "rk94-node07" }
    - { dev_prefix: "/dev/mapper", dev: "dt421", phy_dev: "sda", idx_id: "5",  fs: "tfs1", lnet_suffix: "@tcp2", node: "rk94-node08" }
    - { dev_prefix: "/dev/mapper", dev: "dt422", phy_dev: "sdb", idx_id: "5",  fs: "tfs2", lnet_suffix: "@tcp2", node: "rk94-node08" }
  client:
    - { lnet_suffix: "@tcp2", mount_prefix: "/mnt/lustre0", fs_name: "tfs1", mgsnode: "{{ hostvars[groups['mgs'][0]]['ansible_ssh_host'] }}", net2: "{{ hostvars[groups['client'][0]]['ansible_ssh_host'] }}@tcp2" }
    - { lnet_suffix: "@tcp2", mount_prefix: "/mnt/lustre1", fs_name: "tfs2", mgsnode: "{{ hostvars[groups['mgs'][0]]['ansible_ssh_host'] }}", net2: "{{ hostvars[groups['client'][0]]['ansible_ssh_host'] }}@tcp2" }
    - { lnet_suffix: "@tcp2", mount_prefix: "/mnt/lustre2", fs_name: "tfs3", mgsnode: "{{ hostvars[groups['mgs'][0]]['ansible_ssh_host'] }}", net2: "{{ hostvars[groups['client'][0]]['ansible_ssh_host'] }}@tcp2" }

lustre_server: "{{ _cluster.mgs[0].node }}{{ _cluster.lnet[0].suffix }}"
```

#### 8) Enable Lustre Package Repository
```sh
make lustre r=enable s=repo
```

#### 9) Install Lustre Packages
```sh
make lustre r=install s=pkgs
```

#### 10) Enable Lustre Network
```sh
make lustre r=enable s=network
make lustre r=test s=network
```

#### 11) Format and Mount Lustre Filesystem
```sh
make lustre r=format s=raw
make lustre r=format s=fs
make lustre r=mount s=dir
or
make lustre r=umount s=dir
make lustre r=format s=raw
```

#### 12) Mount or Umount Lustre Clients
```sh
make lustre r=mount s=client
or
make lustre r=uumount s=client
```

#### 13) Install or Uninstall Lustre automatically at once
```sh
make lustre r=install s=all
or
make lustre r=uninstall s=all
```

### Reference
- https://metebalci.com/blog/lustre-2.15.4-on-rhel-8.9-and-ubuntu-22.04/
- https://www.admin-magazine.com/HPC/Articles/Working-with-the-Lustre-Filesystem
- https://wiki.lustre.org/KVM_Quick_Start_Guide
- https://cjy2181.tistory.com/5
- https://workspace.onionmixer.net/wiki/Service_servers
- https://blog.naver.com/skauter/10172784510
- https://gist.github.com/dleske/743f9dafc212b7bb0edce370e961b99e
- https://techcommunity.microsoft.com/blog/azurehighperformancecomputingblog/parallel-virtual-file-systems-on-microsoft-azure---part-2-lustre-on-azure/306524
- https://github.com/storagebit/lure
- https://nischay.pro/blog/lustre-client-setup/
- https://linuxclustersinstitute.org/wp-content/uploads/2021/08/Storage08-Lustre.pdf
- https://info.ornl.gov/sites/publications/Files/Pub166872.pdf

