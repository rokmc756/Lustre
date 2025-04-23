# 2. Check Lustre targets (OSTs, MDTs)

$ lctl dl
0 UP osd-ldiskfs MGS-osd MGS-osd_UUID 5
1 UP mgs MGS MGS 19
2 UP mgc MGC192.168.0.201@tcp a71be537-e6d6-4d67-b706-ffac57f33e9b 5


$ lctl list_nids


# 3. List mounted Lustre clients
$ lfs df

$ lfs df -h


