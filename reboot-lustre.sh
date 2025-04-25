root_pass="changeme"

for i in `seq 0 10`
do

    END_IP=$(( 200 + $i ))
    echo $END_IP

    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.2.$END_IP "reboot"

done

echo 249
sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.2.249 "reboot"

