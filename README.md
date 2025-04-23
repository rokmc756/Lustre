## What is Lustre?


## Lustre Filesystem Architecture
### Diagram
### Abstracting block storage
### Exos Integration
## Lustre Ansible Playbook
This Ansible Playbook provides the feature to build a Lustre Filesystem on Baremetal, Virtual Machines.
The main purposes of this project are simple to deploy Lustre Filesystem quickly and learn knowleges about it.
If you're unfamiliar with Lustre, please refer to the
[Introduction to Linstor section](https://linbit.com/drbd-user-guide/linstor-guide-1_0-en/#p-linstor-introduction)
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
It has been developing based on the following project - https://github.com/
Since above project is not useful to me I modified it with make utility and uninstall tasks for


## Verified Linstor Version
* Lustre x.x.x


## Supported Platform and OS
* Virtual Machines
* Baremetal
* Rocky Linux 9.4


## Usage
Add the target system information into the inventory file named `ansible-hosts-rk9`.
For example:
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[control]
rk9-node01 ansible_ssh_host=192.168.2.191

[server]
rk9-node01 ansible_ssh_host=192.168.2.191
rk9-node02 ansible_ssh_host=192.168.2.192
rk9-node03 ansible_ssh_host=192.168.2.193

[cluster:children]
server

[storage]
rk9-node04 ansible_ssh_host=192.168.2.194
rk9-node05 ansible_ssh_host=192.168.2.195
rk9-node06 ansible_ssh_host=192.168.2.196
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

## Create iSCSI Target and Initiator with Multipath In order to simulate SAN or JBOD Storage
```sh
make iscsi r=create s=target
make iscsi r=create s=client
make iscsi r=enable s=multipath

make iscsi r=disable s=multipath
make iscsi r=delete s=client
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

## Format Lustre Filesystem
```sh
make lustre r=format s=fs
```

## Install Lustre Clients
```sh
make lustre r=install s=client
```

## Reference
- https://metebalci.com/blog/lustre-2.15.4-on-rhel-8.9-and-ubuntu-22.04/

