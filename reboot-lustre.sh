root_pass="changeme"

for i in `seq 1 10`
do

    END_IP=$(( 200 + $i ))
    echo $END_IP
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.2.$END_IP "reboot"

done

# sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.2.249 "reboot"


for j in `seq 48 49`
do

    END_IP=$(( 200 + $j ))
    echo $END_IP
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.2.$END_IP "reboot"

done

