#!/bin/bash

# Creates databases if doesn't exit. User name and password
# are the same as the database name

function create_db_if_non {
	# remove extra quotes
	LIST="${1//\"}"
	for NAME in $LIST
	do
		if [ -z "$(mysql -u root -p${DBROOTPWD} -e "show databases like '$NAME'")" ]; then
			echo "create $NAME"
			mysql -uroot -p${DBROOTPWD}  -e "create database $NAME; GRANT ALL PRIVILEGES ON $NAME.* TO '$NAME'@'%' IDENTIFIED BY '$NAME'"
		fi
	done
}

create_db_if_non "${GENDBLIST}"
