for i in `seq 0 10`
do

    END_IP=$(( 200 + $i ))
    echo $END_IP

    nc -vz 192.168.2.$END_IP 22
    # ssh-keyscan 192.168.2.$END_IP

    ssh-keyscan 192.168.2.$END_IP >/dev/null 2>&1

done
echo 249
nc -vz 192.168.2.249 22
ssh-keyscan 192.168.2.249 >/dev/null 2>&1

