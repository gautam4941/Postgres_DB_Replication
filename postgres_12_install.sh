#!bin/bash

echo "Welcome to Postgres Installation Script\n"

echo "######### 1) Update system#########\n\n"

echo "#########1.a) sudo apt update#########\n"
sudo apt update
if [ 0 -ne $? ]; then
    echo "apt update not done\n"
else
    echo "apt update done\n"
   
    echo "#########1.b) bash-completion wget#########\n"
    sudo apt -y install vim bash-completion wget
    if [ 0 -ne $? ]; then
        echo "bash-completion not done\n"
    else
        echo "bash-completion done\n"
		
	echo "#########1.c) apt upgrade#########\n"
	sudo apt -y upgrade
	if [ 0 -ne $? ]; then
            echo "apt upgrade not done\n"
	else
            echo "apt upgrade done\n"
	fi
    fi
fi

echo "##########2) Add PostgreSQL 12 repository#########\n\n"

echo "2.a) wget apt-key\n"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
if [ 0 -ne $? ]; then
    echo "apt upgrade not done\n"
else
    echo "apt upgrade done\n"

    echo "2.b) Editing pgdg.list"
    echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
    if [ 0 -ne $? ]; then
        echo "pgdg.list file not saved\n"
	exit 1
    else
        echo "pgdg.list file saved\n"
    fi
fi

echo "###########3) Install PostgreSQL 12#########\n\n"

echo "3.a) sudo apt update\n"
sudo apt update
if [ 0 -ne $? ]; then
    echo "sudo apt update not done\n"
else
    echo "sudo apt update done\n"
	
    echo "3.b) Installing postgresql-12\n"
    sudo apt -y install postgresql-12
    if [ 0 -ne $? ]; then
        echo "postgresql-12 Packages Installaion Failure\n"
    else
        echo "postgresql-12 Packages Installed Succuessfully\n"
		
        echo "3.c) Installing postgresql-client-12\n"
        sudo apt -y install postgresql-client-12
        if [ 0 -ne $? ]; then
            echo "postgresql-client-12 Packages Installed Failure\n"
        else
            echo "postgresql-client-12 Packages Installaton Succuessfully\n"
			
	fi
    fi
fi

echo "###########4) Confirming PostgreSQL Installaion#########\n\n"

echo "4.a) postgresql.service\n"
systemctl status postgresql.service 
if [ 0 -ne $? ]; then
    echo "postgresql.service not working"
else
    echo "postgresql.service working"
fi

echo "4.b) postgresql@12-main.service \n"
systemctl status postgresql@12-main.service 
if [ 0 -ne $? ]; then
    echo "postgresql.service not working"
else
    echo "postgresql.service working"
fi

echo "4.c) is-enabled postgresql \n"
systemctl is-enabled postgresql
if [ 0 -ne $? ]; then
    echo "postgresql is not enabled\d"
else
    echo "postgresql is enabled\d"
fi
