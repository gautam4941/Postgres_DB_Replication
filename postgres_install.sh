#!bin/bash

echo "Welcome to Postgres Installation Script"

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

if [ 0 -ne $? ]; then
   echo "pgdg.list Editing not Done"
    exit 1
else
   echo "pgdg.list Editing Done"

   sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
   if [ 0 -ne $? ]; then
        echo "wget Not Done"
        exit 1
   else
        echo "wget Done"

        sudo apt -y update
        if [ 0 -ne $? ]; then
            echo "update Not Done"
            exit 1
        else
            echo "update Done"

            sudo apt -y install postgresql-14
            if [ 0 -ne $? ]; then
                echo "postgresql-14 Not Done"
                exit 1
            else
                echo "postgresql-14 Done"

                sudo systemctl status postgresql
                if [ 0 -ne $? ]; then
                    echo "postgresql Status Not Done"
                    exit 1
                else
                    echo "postgresql Status Done"
                    exit 0
                fi
            fi

        fi

   fi

fi
