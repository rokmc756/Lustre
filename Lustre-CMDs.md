[ On Lustre Clients ]

### Check Disk Usage
```bash
$ df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     7.6G     0  7.6G   0% /dev/shm
tmpfs                     3.1G  8.7M  3.1G   1% /run
/dev/mapper/rl-root        62G  3.1G   59G   5% /
/dev/vda1                 960M  231M  730M  24% /boot
/dev/mapper/rl-home        30G  248M   30G   1% /home
192.168.2.201@tcp2:/tfs1   28G  105M   26G   1% /mnt/lustre0/tfs1
192.168.2.201@tcp2:/tfs2   28G  105M   26G   1% /mnt/lustre1/tfs2
192.168.2.201@tcp2:/tfs3   19G  103M   18G   1% /mnt/lustre2/tfs3
tmpfs                     1.6G     0  1.6G   0% /run/user/0
```


### List all MDTs (Metadata Targets
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


### Verify MDTs per Filesystem
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

### List Space Usage
```bash
$ lfs df -h /mnt/lustre0/tfs1
UUID                       bytes        Used   Available Use% Mounted on
tfs1-MDT0000_UUID           5.5G        2.2M        5.0G   1% /mnt/lustre0/tfs1[MDT:0]
tfs1-MDT0001_UUID           5.5G        1.9M        5.0G   1% /mnt/lustre0/tfs1[MDT:1]
tfs1-MDT0002_UUID           5.5G        1.9M        5.0G   1% /mnt/lustre0/tfs1[MDT:2]
tfs1-OST0003_UUID           9.2G      101.6M        8.6G   2% /mnt/lustre0/tfs1[OST:3]
tfs1-OST0004_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre0/tfs1[OST:4]
tfs1-OST0005_UUID           9.2G        1.6M        8.7G   1% /mnt/lustre0/tfs1[OST:5]

filesystem_summary:        27.5G      104.9M       25.9G   1% /mnt/lustre0/tfs1
```

### List OSTs
```bash
$ lfs osts /mnt/lustre0/tfs1
OBDS:
3: tfs1-OST0003_UUID ACTIVE
4: tfs1-OST0004_UUID ACTIVE
5: tfs1-OST0005_UUID ACTIVE
```

### Set Quotas
```bash
$ lfs setquota -u username -b 1000000 -B 2000000 /mnt/lustre
```


### List Disk Usage and Quotas
```bash
$ lfs quota -h -v -u root /mnt/lustre0/tfs1
Disk quotas for usr root (uid 0):
      Filesystem    used   quota   limit   grace   files   quota   limit   grace
/mnt/lustre0/tfs1  109.5M      0k      0k       -     786       0       0       -
    tfs1-MDT0000  1.797M       -      0k       -     286       -       0       -
    tfs1-MDT0001  1.469M       -      0k       -     250       -       0       -
    tfs1-MDT0002  1.469M       -      0k       -     250       -       0       -
    tfs1-OST0003  101.6M       -      0k       -       -       -       -       -
    tfs1-OST0004  1.598M       -      0k       -       -       -       -       -
    tfs1-OST0005  1.598M       -      0k       -       -       -       -       -
Total allocated inode limit: 0, total allocated block limit: 0k
```

```bash
$ lfs quota -h -u root /mnt/lustre0/tfs1
Disk quotas for usr root (uid 0):
      Filesystem    used   quota   limit   grace   files   quota   limit   grace
```


### List Inode Usage
```bash
$ lfs df -i
UUID                      Inodes       IUsed       IFree IUse% Mounted on
tfs1-MDT0000_UUID        4194304         296     4194008   1% /mnt/lustre0/tfs1[MDT:0]
tfs1-MDT0001_UUID        4194304         260     4194044   1% /mnt/lustre0/tfs1[MDT:1]
tfs1-MDT0002_UUID        4194304         260     4194044   1% /mnt/lustre0/tfs1[MDT:2]
tfs1-OST0003_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:3]
tfs1-OST0004_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:4]
tfs1-OST0005_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:5]

filesystem_summary:      1965594         816     1964778   1% /mnt/lustre0/tfs1

UUID                      Inodes       IUsed       IFree IUse% Mounted on
tfs2-MDT0000_UUID        4194304         274     4194030   1% /mnt/lustre1/tfs2[MDT:0]
tfs2-MDT0001_UUID        4194304         258     4194046   1% /mnt/lustre1/tfs2[MDT:1]
tfs2-OST0003_UUID         655360         368      654992   1% /mnt/lustre1/tfs2[OST:3]
tfs2-OST0004_UUID         655360         368      654992   1% /mnt/lustre1/tfs2[OST:4]
tfs2-OST0005_UUID         655360         368      654992   1% /mnt/lustre1/tfs2[OST:5]

filesystem_summary:      1965508         532     1964976   1% /mnt/lustre1/tfs2

UUID                      Inodes       IUsed       IFree IUse% Mounted on
tfs3-MDT0000_UUID        4194304         272     4194032   1% /mnt/lustre2/tfs3[MDT:0]
tfs3-MDT0001_UUID        4194304         257     4194047   1% /mnt/lustre2/tfs3[MDT:1]
tfs3-OST0002_UUID         655360         368      654992   1% /mnt/lustre2/tfs3[OST:2]
tfs3-OST0003_UUID         655360         368      654992   1% /mnt/lustre2/tfs3[OST:3]

filesystem_summary:      1310513         529     1309984   1% /mnt/lustre2/tfs3
```


```bash
$ lfs df -i /mnt/lustre0/tfs1
UUID                      Inodes       IUsed       IFree IUse% Mounted on
tfs1-MDT0000_UUID        4194304         296     4194008   1% /mnt/lustre0/tfs1[MDT:0]
tfs1-MDT0001_UUID        4194304         260     4194044   1% /mnt/lustre0/tfs1[MDT:1]
tfs1-MDT0002_UUID        4194304         260     4194044   1% /mnt/lustre0/tfs1[MDT:2]
tfs1-OST0003_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:3]
tfs1-OST0004_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:4]
tfs1-OST0005_UUID         655360         434      654926   1% /mnt/lustre0/tfs1[OST:5]

filesystem_summary:      1965594         816     1964778   1% /mnt/lustre0/tfs1
```

$ lfs mdts /mnt/lustre2/tfs3/
MDTS:
0: tfs3-MDT0000_UUID ACTIVE
1: tfs3-MDT0001_UUID ACTIVE

$ lfs osts /mnt/lustre2/tfs3/
OBDS:
2: tfs3-OST0002_UUID ACTIVE
3: tfs3-OST0003_UUID ACTIVE


### Check MGTs
$ lfs check mgts /mnt/lustre0/tfs1
MGC192.168.2.201@tcp2 active.


### Check MDTs
$ lfs check mdts /mnt/lustre0/tfs1
tfs1-MDT0000-mdc-ffff93af0c638800 active.
tfs1-MDT0001-mdc-ffff93af0c638800 active.
tfs1-MDT0002-mdc-ffff93af0c638800 active.

### Check OSTs
$ lfs check osts /mnt/lustre0/tfs1
tfs1-OST0003-osc-ffff93af0c638800 active.
tfs1-OST0004-osc-ffff93af0c638800 active.
tfs1-OST0005-osc-ffff93af0c638800 active.

### Check All
$ lfs check all /mnt/lustre0/tfs1
tfs1-OST0003-osc-ffff93af0c638800 active.
tfs1-OST0004-osc-ffff93af0c638800 active.
tfs1-OST0005-osc-ffff93af0c638800 active.
tfs1-MDT0000-mdc-ffff93af0c638800 active.
tfs1-MDT0001-mdc-ffff93af0c638800 active.
tfs1-MDT0002-mdc-ffff93af0c638800 active.


### Display Network Interfaces
$ lctl list_nids
192.168.0.209@tcp
192.168.2.209@tcp2


### X
```bash
$ lfs osts
OBDS:
3: tfs1-OST0003_UUID ACTIVE
4: tfs1-OST0004_UUID ACTIVE
5: tfs1-OST0005_UUID ACTIVE
OBDS:
3: tfs2-OST0003_UUID ACTIVE
4: tfs2-OST0004_UUID ACTIVE
5: tfs2-OST0005_UUID ACTIVE
OBDS:
2: tfs3-OST0002_UUID ACTIVE
3: tfs3-OST0003_UUID ACTIVE
```


### X
```bash
$ lfs getstripe -O tfs1-OST0003_UUID /mnt/lustre0/tfs1
/mnt/lustre0/tfs1/test6
lmm_stripe_count:  1
lmm_stripe_size:   4194304
lmm_pattern:       raid0
lmm_layout_gen:    0
lmm_stripe_offset: 3
        obdidx           objid           objid           group
             3               2            0x2      0x2c0000402 *
```

### X
```bash
$ pwd
/mnt/lustre2/tfs3

$ lfs find . -type f -print0 | while IFS='' read -d '' i; do echo "$i"; lfs getstripe -q "$i"; done
./test8
./test8
        obdidx           objid           objid           group
             3               2            0x2      0x280000401

$ lfs data_version test8
4294967325


$ lfs find .
.
./test8


$ lfs getname
tfs1-ffff93af0c638800 /mnt/lustre0/tfs1
tfs2-ffff93af2c7a6800 /mnt/lustre1/tfs2
tfs3-ffff93af04dc8000 /mnt/lustre2/tfs3


$ lfs pool_list /mnt/lustre0/tfs1

```


[ On MGS Node ]
```sh
$ cat /proc/fs/lustre/mgs/MGS/live/tfs1
fsname: tfs1
flags: 0x20     gen: 34
tfs1-MDT0000
tfs1-MDT0001
tfs1-MDT0002
tfs1-OST0003
tfs1-OST0004
tfs1-OST0005

Secure RPC Config Rules:

imperative_recovery_state:
    state: full
    nonir_clients: 0
    nidtbl_version: 14
    notify_duration_total: 0.001220555
    notify_duation_max: 0.000794475
    notify_count: 6
```


```bash
$ cat /proc/fs/lustre/mgs/MGS/osd/brw_stats
snapshot_time:            1749842360.843230012 secs.nsecs
start_time:               1749839110.444966841 secs.nsecs
elapsed_time:             3250.398263171 secs.nsecs

                           read      |     write
pages per bulk r/w     rpcs  % cum % |  rpcs        % cum %

                           read      |     write
discontiguous pages    rpcs  % cum % |  rpcs        % cum %

                           read      |     write
discontiguous blocks   rpcs  % cum % |  rpcs        % cum %

                           read      |     write
disk fragmented I/Os   ios   % cum % |  ios         % cum %

                           read      |     write
disk I/Os in flight    ios   % cum % |  ios         % cum %

                           read      |     write
I/O time (1/1000s)     ios   % cum % |  ios         % cum %

                           read      |     write
disk I/O size          ios   % cum % |  ios         % cum %

                           read      |     write
block maps msec        maps  % cum % |  maps        % cum %
```

### List of all Lustre nodes,
```sh
$ lctl get_param mgs.MGS.live.*
mgs.MGS.live.params=
fsname: params
flags: 0x20     gen: 1

Secure RPC Config Rules:

imperative_recovery_state:
    state: full
    nonir_clients: 0
    nidtbl_version: 2
    notify_duration_total: 0.000000000
    notify_duation_max: 0.000000000
    notify_count: 0
mgs.MGS.live.tfs1=
fsname: tfs1
flags: 0x20     gen: 34
tfs1-MDT0000
tfs1-MDT0001
tfs1-MDT0002
tfs1-OST0003
tfs1-OST0004
tfs1-OST0005

Secure RPC Config Rules:

imperative_recovery_state:
    state: full
    nonir_clients: 0
    nidtbl_version: 14
    notify_duration_total: 0.001220555
    notify_duation_max: 0.000794475
    notify_count: 6
mgs.MGS.live.tfs2=
fsname: tfs2
flags: 0x20     gen: 24
tfs2-MDT0000
tfs2-MDT0001
tfs2-OST0003
tfs2-OST0004
tfs2-OST0005

Secure RPC Config Rules:

imperative_recovery_state:
    state: full
    nonir_clients: 0
    nidtbl_version: 12
    notify_duration_total: 0.001055995
    notify_duation_max: 0.000548262
    notify_count: 5
mgs.MGS.live.tfs3=
fsname: tfs3
flags: 0x20     gen: 20
tfs3-MDT0000
tfs3-MDT0001
tfs3-OST0002
tfs3-OST0003

Secure RPC Config Rules:

imperative_recovery_state:
    state: full
    nonir_clients: 0
    nidtbl_version: 10
    notify_duration_total: 0.000754189
    notify_duation_max: 0.000694436
    notify_count: 4
```


```sh
$ lctl --device MGS llog_print tfs1-MDT0000
- { index: 2, event: attach, device: tfs1-MDT0000-mdtlov, type: lov, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 3, event: setup, device: tfs1-MDT0000-mdtlov, UUID:  }
- { index: 6, event: attach, device: tfs1-MDT0000, type: mdt, UUID: tfs1-MDT0000_UUID }
- { index: 7, event: new_profile, name: tfs1-MDT0000, lov: tfs1-MDT0000-mdtlov }
- { index: 8, event: setup, device: tfs1-MDT0000, UUID: tfs1-MDT0000_UUID, node: 0, options: tfs1-MDT0000-mdtlov, failout: f }
- { index: 11, event: add_uuid, nid: 192.168.0.202@tcp(0x20000c0a800ca), node: 192.168.0.202@tcp }
- { index: 12, event: add_uuid, nid: 192.168.2.202@tcp2(0x20002c0a802ca), node: 192.168.0.202@tcp }
- { index: 13, event: attach, device: tfs1-MDT0001-osp-MDT0000, type: osp, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 14, event: setup, device: tfs1-MDT0001-osp-MDT0000, UUID: tfs1-MDT0001_UUID, node: 192.168.0.202@tcp }
- { index: 15, event: add_mdc, device: tfs1-MDT0000-mdtlov, mdt: tfs1-MDT0001_UUID, index: 1, gen: 1 }
- { index: 18, event: add_uuid, nid: 192.168.0.203@tcp(0x20000c0a800cb), node: 192.168.0.203@tcp }
- { index: 19, event: add_uuid, nid: 192.168.2.203@tcp2(0x20002c0a802cb), node: 192.168.0.203@tcp }
- { index: 20, event: attach, device: tfs1-MDT0002-osp-MDT0000, type: osp, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 21, event: setup, device: tfs1-MDT0002-osp-MDT0000, UUID: tfs1-MDT0002_UUID, node: 192.168.0.203@tcp }
- { index: 22, event: add_mdc, device: tfs1-MDT0000-mdtlov, mdt: tfs1-MDT0002_UUID, index: 2, gen: 1 }
- { index: 25, event: add_uuid, nid: 192.168.0.205@tcp(0x20000c0a800cd), node: 192.168.0.205@tcp }
- { index: 26, event: add_uuid, nid: 192.168.2.205@tcp2(0x20002c0a802cd), node: 192.168.0.205@tcp }
- { index: 27, event: attach, device: tfs1-OST0003-osc-MDT0000, type: osc, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 28, event: setup, device: tfs1-OST0003-osc-MDT0000, UUID: tfs1-OST0003_UUID, node: 192.168.0.205@tcp }
- { index: 29, event: add_osc, device: tfs1-MDT0000-mdtlov, ost: tfs1-OST0003_UUID, index: 3, gen: 1 }
- { index: 32, event: add_uuid, nid: 192.168.0.208@tcp(0x20000c0a800d0), node: 192.168.0.208@tcp }
- { index: 33, event: add_uuid, nid: 192.168.2.208@tcp2(0x20002c0a802d0), node: 192.168.0.208@tcp }
- { index: 34, event: attach, device: tfs1-OST0005-osc-MDT0000, type: osc, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 35, event: setup, device: tfs1-OST0005-osc-MDT0000, UUID: tfs1-OST0005_UUID, node: 192.168.0.208@tcp }
- { index: 36, event: add_osc, device: tfs1-MDT0000-mdtlov, ost: tfs1-OST0005_UUID, index: 5, gen: 1 }
- { index: 39, event: add_uuid, nid: 192.168.0.206@tcp(0x20000c0a800ce), node: 192.168.0.206@tcp }
- { index: 40, event: add_uuid, nid: 192.168.2.206@tcp2(0x20002c0a802ce), node: 192.168.0.206@tcp }
- { index: 41, event: attach, device: tfs1-OST0004-osc-MDT0000, type: osc, UUID: tfs1-MDT0000-mdtlov_UUID }
- { index: 42, event: setup, device: tfs1-OST0004-osc-MDT0000, UUID: tfs1-OST0004_UUID, node: 192.168.0.206@tcp }
- { index: 43, event: add_osc, device: tfs1-MDT0000-mdtlov, ost: tfs1-OST0004_UUID, index: 4, gen: 1 }


$ lctl --device MGS llog_print tfs1-OST0003
- { index: 2, event: attach, device: tfs1-OST0003, type: obdfilter, UUID: tfs1-OST0003_UUID }
- { index: 3, event: setup, device: tfs1-OST0003, UUID: dev, node: type, options: f }
```

[ On MDS Nodes ]
```bash
$ lctl --device tfs1-MDT0000 changelog_register --user monitor --mask UNLNK,CLOSE
tfs1-MDT0000: Registered changelog userid 'cl1-monitor'

$ lctl --device tfs1-MDT0000 changelog_deregister cl1-monitor
tfs1-MDT0000: Deregistered changelog user #1

$ lctl get_param mdt.*.job_stats
mdt.tfs1-MDT0000.job_stats=job_stats:
```

### The name of all OSTs
```sh
$ lctl get_param lov.*-mdtlov.target_obd
lov.tfs1-MDT0001-mdtlov.target_obd=
3: tfs1-OST0003_UUID ACTIVE
4: tfs1-OST0004_UUID ACTIVE
5: tfs1-OST0005_UUID ACTIVE
lov.tfs2-MDT0000-mdtlov.target_obd=
3: tfs2-OST0003_UUID ACTIVE
4: tfs2-OST0004_UUID ACTIVE
5: tfs2-OST0005_UUID ACTIVE
```

[ On OSS Nodes ]
```bash
$ lctl get_param obdfilter.*.job_stats
obdfilter.tfs1-OST0003.job_stats=job_stats:
obdfilter.tfs2-OST0003.job_stats=job_stats:
```

[ On Client Nodes ]
```bash
$ lctl get_param jobid_var
jobid_var=disable
```

```bash
$ lctl get_param osc.*.ost_conn_uuid
osc.tfs1-OST0003-osc-ffff93af0c638800.ost_conn_uuid=192.168.0.205@tcp
osc.tfs1-OST0004-osc-ffff93af0c638800.ost_conn_uuid=192.168.0.206@tcp
osc.tfs1-OST0005-osc-ffff93af0c638800.ost_conn_uuid=192.168.0.208@tcp
osc.tfs2-OST0003-osc-ffff93af2c7a6800.ost_conn_uuid=192.168.0.205@tcp
osc.tfs2-OST0004-osc-ffff93af2c7a6800.ost_conn_uuid=192.168.0.207@tcp
osc.tfs2-OST0005-osc-ffff93af2c7a6800.ost_conn_uuid=192.168.0.208@tcp
osc.tfs3-OST0002-osc-ffff93af04dc8000.ost_conn_uuid=192.168.0.206@tcp
osc.tfs3-OST0003-osc-ffff93af04dc8000.ost_conn_uuid=192.168.0.207@tcp
```



## References
- https://www.nas.nasa.gov/hecc/support/kb/lustre-basics_224.html


## Progress
- 136 Page in lustre_manual.pdf


