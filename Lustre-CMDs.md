[ On Lustre Clients ]

## List all MDTs (Metadata Targets
```bash
$ lctl dl
  0 UP mgc MGC192.168.2.201@tcp2 cf4db06a-db1d-4078-8bfd-5ed5df929d4e 5
  1 UP lov tfs1-clilov-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 4
  2 UP lmv tfs1-clilmv-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  3 UP mdc tfs1-MDT0000-mdc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  4 UP mdc tfs1-MDT0001-mdc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  5 UP mdc tfs1-MDT0002-mdc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  6 UP osc tfs1-OST0005-osc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  7 UP osc tfs1-OST0003-osc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  8 UP osc tfs1-OST0006-osc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
  9 UP osc tfs1-OST0004-osc-ffff98b6c7c05000 74b62f4e-9b8d-43f3-a3f7-078835814cd8 5
```

## Verify MDTs per Filesystem
```bash
$ lfs df -h
UUID                       bytes        Used   Available Use% Mounted on
tfs1-MDT0000_UUID           5.5G        2.0M        5.0G   1% /mnt/lustre/tfs1[MDT:0]
tfs1-MDT0001_UUID           5.5G        1.9M        5.0G   1% /mnt/lustre/tfs1[MDT:1]
tfs1-MDT0002_UUID           5.5G        1.9M        5.0G   1% /mnt/lustre/tfs1[MDT:2]
tfs1-OST0003_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre/tfs1[OST:3]
tfs1-OST0004_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre/tfs1[OST:4]
tfs1-OST0005_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre/tfs1[OST:5]
tfs1-OST0006_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre/tfs1[OST:6]
filesystem_summary:        36.7G        6.5M       34.7G   1% /mnt/lustre/tfs1
```

### Check Filesystems
```bash
[root@rk94-node09 ~]# df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     7.6G     0  7.6G   0% /dev/shm
tmpfs                     3.1G  8.7M  3.1G   1% /run
/dev/mapper/rl-root        62G  3.1G   59G   5% /
/dev/vda1                 960M  231M  730M  24% /boot
/dev/mapper/rl-home        30G  247M   30G   1% /home
192.168.2.201@tcp2:/tfs1   37G  6.6M   35G   1% /mnt/lustre/tfs1
tmpfs                     1.6G     0  1.6G   0% /run/user/0
```

### Check Filesystem Layout and Striping
```bash
$ lfs getdirstripe /mnt/lustre/tfs1/
lmv_stripe_count: 0 lmv_stripe_offset: 0 lmv_hash_type: none
mdtidx           FID[seq:oid:ver]
```

### Cheeck with lfs tool directly
```bash
$ lfs df -m
UUID                   1K-blocks        Used   Available Use% Mounted on
tfs1-MDT0000_UUID        5781172        2052     5256288   1% /mnt/lustre/tfs1[MDT:0]
tfs1-MDT0001_UUID        5781172        1972     5256368   1% /mnt/lustre/tfs1[MDT:1]
tfs1-MDT0002_UUID        5781172        1972     5256368   1% /mnt/lustre/tfs1[MDT:2]
filesystem_summary:     17343516        5996    15769024   1% /mnt/lustre/tfs1
```

### Advanced
```bash
$ lctl get_param mdt.*.mdt_num
error: get_param: param_path 'mdt/*/mdt_num': No such file or directory
```

