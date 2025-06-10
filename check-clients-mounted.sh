for i in `seq 209 210`
do

    ssh root@192.168.2.$i "mount -l | grep -E 'smb|ceph|iscsi|lustre'"

done

# for i in `find ./ -name "*2023-03-21*.csv"`; do grep --with-filename -E 'FATAL\:|ERROR\:' $i; done

