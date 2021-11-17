#!bin/bash

# Ref :- https://www.postgresql.r2schools.com/how-to-setup-streaming-replication-in-postgresql-step-by-step-on-ubuntu/

echo "\t\t##################Master Postgres Replication##################\n\n" ;

slave_ip=$1 ;
echo "Slave IP = $slave_ip" ;

echo "\t\tStep 1 : Configurations on master server\n"

echo "1) cd /etc/postgresql/14/main/"
cd /etc/postgresql/14/main/
if [ 0 -ne $? ]; then
    echo "Status : Failure \n"
    exit 1
else
    echo "Status : Success \n"
	
	echo "1.a) ls postgresql_old.conf \n"
    ls postgresql_old.conf
    if [ 0 -ne $? ]; then
        echo "Status : Failure \n"
        
		echo "1.a.a) cp postgresql.conf postgresql_old.conf \n"
        sudo cp postgresql.conf postgresql_old.conf
        if [ 0 -ne $? ]; then
            echo "Status : Failure \n"
            exit 1
        else
            echo "Status : Success \n"
        fi
		
    else
        echo "Status : Success \n"
    fi
   
	echo "1.b) changing listen_addresses \n"
    sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" postgresql.conf
    if [ 0 -ne $? ]; then
        echo "Status : Failure \n"
    else
        echo "Status : Success \n"
    fi
	
	echo "1.c) Checking Replication user"
	sudo -i -u postgres bash -c "psql -c \"\du\"" | awk '{print $1}' | grep -i replicator
	if [ 0 -ne $? ]; then
        echo "Status : Failure \n"
        
		echo "1.c.a) Create Replication"
	    sudo -i -u postgres bash -c "psql -c \"CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'admin@123';\""
	    if [ 0 -ne $? ]; then
            echo "Status : Failure \n"
            exit 1
        else
            echo "Status : Success \n"
        fi
		
        echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
        sleep 3
		
    else
        echo "Status : Success \n"
    fi
		
    echo "1.d) ls pg_hba_old.conf\n"
    ls pg_hba_old.conf
    if [ 0 -ne $? ]; then
        echo "Status : Failure \n"
        
        echo "1.d.a) cp postgresql.conf postgresql_old.conf \n"
        sudo cp pg_hba.conf pg_hba_old.conf
        if [ 0 -ne $? ]; then
            echo "Status : Failure \n"
            exit 1
        else
            echo "Status : Success \n"
        fi
		
        echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
        sleep 3

    else
        echo "Status : Success \n"
    fi
	
    echo "1.e) Checking if replicator user already exists inn pg_hba.conf file"
    sudo less pg_hba.conf | grep -i replicator
    if [ 0 -ne $? ]; then
    
        echo "PWD = "
		pwd
        echo "1.e.a) chmod 777 pg_hba.conf"
        sudo chmod 777 pg_hba.conf
    	if [ 0 -ne $? ]; then
    		echo "Status : Failure \n"
            exit 1
    	else
    	    echo "Status : Success \n"
    	fi
    
        echo "1.e.b) Adding slave_ip and replication user details in pg_hba \n"
        sudo echo "host    replication     replicator      $slave_ip/24        md5" >> pg_hba.conf
        if [ 0 -ne $? ]; then
            echo "Status : Failure \n"
            exit 1
        else
            echo "Status : Success \n"
        fi
		
        echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
        sleep 3
    
    else
        echo "replicator user Already exists\n"
    fi
    
	echo "1.f) sudo systemctl restart postgresql\n"
    sudo systemctl restart postgresql
    if [ 0 -ne $? ]; then
        echo "Status : Failure \n"
        exit 1
    else
        echo "Status : Success \n"
		
	fi
	
    echo "\nWaiting for 3 Seconds. Do not press anything on Terminal !!!\n"
    sleep 3
	
	echo "1.g) systemctl status postgresql\n"
	sudo systemctl status postgresql
	if [ 0 -ne $? ]; then
		echo "Status : Failure \n"
		exit 1
	else
		echo "Status : Success \n"
	fi

fi
