#!bin/bash

echo $psql -V
if [ 0 -ne $? ]; then
    echo "Postgres is not installed \n"
    exit 1
else
        echo "Postgres Exists\n"
        echo "Going to uninstall following postgres related packages, "
        dpkg -l | grep postgres | awk '{print $2}' | tee postgres_modules_list.txt

        awk_output="sudo apt-get --purge remove "
        while IFS= read -r line; do
            awk_output="$awk_output $line"
        done < postgres_modules_list.txt

        echo "\nCommand to Uninstall Packages :- \n"$awk_output ;

        eval $awk_output ;

        if [ 0 -ne $? ]; then
            echo "\nError While removing packages"
        else
            echo "\nPostgres Packages Removed"
            echo "Going to remove postgres Paths"

            echo "\nWaiting for 5 Seconds. Do not press anything on Terminal !!!"
            sleep 5

            sudo rm -rfv /var/lib/postgresql/
            if [ 0 -ne $? ]; then
                echo "\nCould not remove /var/lib/postgresql/"
            else
                echo "\n /var/lib/postgresql/ Removed Successfully"
            fi

            sudo rm -rfv /var/log/postgresql/
            if [ 0 -ne $? ]; then
                echo "\n Could not remove /var/log/postgresql/"
            else
                echo "\n /var/log/postgresql/ Removed Successfully"
            fi

            sudo rm -rfv /etc/postgresql/
            if [ 0 -ne $? ]; then
                echo "\n Could not remove /etc/postgresql/"
            else
                echo "\n /etc/postgresql/ Removed Successfully"
            fi

            sudo deluser postgres
            if [ 0 -ne $? ]; then
                echo "\n Not able to Remove postgres users"
            else
                echo "\n postgres user deletion Done"
            fi
        fi
fi

# sudo apt autoremove
# if [ 0 -ne $? ]; then
#     echo "Error While autoremove."
#     exit 1
# else
#     echo "Removed all un-required dependencies"
#     exit 0
# fi
