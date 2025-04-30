## What is Lustre?
Lustre* is an open-source, global single-namespace, POSIX-compliant, distributed parallel file system designed for scalability, high-performance, and high-availability.

Lustre runs on Linux-based operating systems and employs a client-server network architecture. Storage is provided by a set of servers that can scale to populations measuring up to several hundred hosts.

Lustre servers for a single file system instance can, in aggregate, present up to hundreds of petabytes of storage to thousands of compute clients, with multiple terabytes per second of combined throughput.

Lustre is a file system that scales to meet the requirements of applications running on a range of systems from small-scale HPC environments up to the very largest supercomputers and has been created using object-based storage building blocks to maximize scalability.

Redundant servers support storage fail-over, while metadata and data are stored on separate servers, allowing each file system to be optimized for different workloads.

Lustre can deliver fast IO to applications across high-speed network fabrics, such as Ethernet, InfiniBand (IB), Omni-Path (OPA), and others.

## Lustre Filesystem Architecture
<p align="center">
<img src="https://github.com/rokmc756/Lustre/blob/main/roles/lustre/images/lustre_file_system_overview_dne_lowres_v1.png" width="70%" height="70%">
</p>

## Lustre Ansible Playbook
This Ansible Playbook provides the feature to build a Lustre Filesystem on Baremetal, Virtual Machines.
The main purposes of this project are simple to deploy Lustre Filesystem quickly and learn knowleges about it.
If you're unfamiliar with Lustre, please refer to the
[Introduction to Lustre](https://wiki.lustre.org/Introduction_to_Lustre)

of the Linstor user's guide on https://linbit.com to learn more.

**`System requirements`**:
  - All target systems must have passwordless SSH access.
  - All hostnames used in the inventory file are resolvable (or use IP addresses).
  - MacOS or Linux(or WSL) should have installed ansible as Ansible Host.
  - At least a Normal User which has Sudo Privileges


## Prepare ansible host to run this playbook
* MacOS
```!yaml
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

## Where is it originated?
It has been developing based on the following project - https://github.com/stackhpc/ansible-lustre/tree/master/ansible
Since above project is not useful to me, I modified it with make utility.


## Verified Lustre Version
* Lustre 2.16.x


## Supported Platform and OS
* Virtual Machines
* Baremetal
* Rocky Linux 9.4


## Usage
Add the target system information into the inventory file named `ansible-hosts`.
For example:
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"


[iscsi]
rk94-node00 ansible_ssh_host=192.168.2.200 ansible_ssh_host1=192.168.0.200
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

```sh
$ vi group_vars/all.yaml
---
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"
ansible_ssh_private_key_file: ~/.ssh/ansible_key
```

When ready, run the make commands
## Initialize or Uninitialize Linux Host to install packages required and generate/exchange ssh keys among all hosts.
```sh
make hosts r=init          # or uninit
```

## Create or Delete iSCSI Target and Initiator with Multipath In order to simulate SAN or JBOD Storage
```sh
make iscsi r=create s=target
make iscsi r=create s=initiator
make iscsi r=enable s=multipath

or

make iscsi r=disable s=multipath
make iscsi r=delete s=initiator
make iscsi r=delete s=target
```

## Install Lustre Packages
```sh
make lustre r=install s=pkgs
```

## Install Lustre Network
```sh
make lustre r=enable s=network
make lustre r=test s=network
```

## Format and Mount Lustre Filesystem
```sh
make lustre r=format s=fs
make lustre r=mount s=dir
```

## Install Lustre Clients
```sh
make lustre r=install s=client
```

## Reference
- https://metebalci.com/blog/lustre-2.15.4-on-rhel-8.9-and-ubuntu-22.04/
- https://cjy2181.tistory.com/5
- https://techcommunity.microsoft.com/blog/azurehighperformancecomputingblog/parallel-virtual-file-systems-on-microsoft-azure---part-2-lustre-on-azure/306524
- https://github.com/storagebit/lure

