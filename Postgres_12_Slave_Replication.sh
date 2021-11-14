#!bin/bash

echo "\t\t##################Salve Postgres Replication##################\n\n" ;

master_ip=$1 ;
echo "Master IP = $master_ip" ;

echo "1) sudo systemctl start postgresql \n"
sudo systemctl start postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "2) systemctl status postgresql \n"
sudo systemctl status postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "3) sudo systemctl stop postgresql \n"
sudo systemctl stop postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "4) systemctl status postgresql \n"
sudo systemctl status postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
else
	echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "5) ls /var/lib/postgresql/12/main_old \n"
sudo ls /var/lib/postgresql/12/main_old
if [ 0 -ne $? ]; then
    echo "Status : Failure \n"
    
    echo "4.a) cp -R /var/lib/postgresql/12/main /var/lib/postgresql/12/main_old \n"
	sudo -i -u postgres bash -c "cp -R /var/lib/postgresql/12/main /var/lib/postgresql/12/main_old"
    if [ 0 -ne $? ]	; then
        echo "Status : Failure \n"
        exit 1
    else
        echo "Status : Success \n"
    fi
	
else
    echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3


echo "6) ls /var/lib/postgresql/12/main/ \n"
if [ 0 -ne $? ]	; then
	echo "Status : Failure \n"
else
	echo "Status : Success \n"
	
    echo "6.a) rm -rf /var/lib/postgresql/12/main/ \n"
    sudo -i -u postgres bash -c "rm -rf /var/lib/postgresql/12/main/"
    if [ 0 -ne $? ]; then
    	echo "Status : Failure \n"
    	exit 1
    else
        echo "Status : Success \n"
    fi
	
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3


echo "7) Creating pg_basebackup main folder \n"
sudo -i -u postgres bash -c "pg_basebackup -h $master_ip -D /var/lib/postgresql/12/main/ -U replicator -P -v -R -X stream -C -S slaveslot1"
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"

	echo "7.a)ls /var/lib/postgresql/12/main/standby.signal \n"
	sudo ls /var/lib/postgresql/12/main/standby.signal
	if [ 0 -ne $? ]; then
		echo "Status : Failure \n"
		exit 1
	else
		echo "Status : Success \n"
	fi
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "8)sudo systemctl start postgresql\n"
sudo systemctl start postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"
fi

echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
sleep 3

echo "9) systemctl status postgresql \n"
sudo systemctl status postgresql
if [ 0 -ne $? ]; then
	echo "Status : Failure \n"
	exit 1
else
	echo "Status : Success \n"
fi

