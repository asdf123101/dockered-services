#!/bin/bash

# Creates databases if doesn't exit. User name and password
# are the same as the database name

function create_db_if_non {
	for NAME in "$@"
		do
			if [ -z "$(mysql -u $DBROOTNAME -p $DBROOTPWD -e "show databases like '$NAME'")" ]; then
				echo "create $NAME"
				mysql -uroot -proot -e "create database $NAME; \
				GRANT ALL PRIVILEGES ON $NAME.* TO \
				'$NAME'@'%' IDENTIFIED BY '$NAME'"
			fi
		done
}

create_db_if_non ${GENDBLIST}
