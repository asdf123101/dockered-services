This is a template for setting up gogs and/or nextcloud on a server.
Before calling `docker-compose`, create a file `.env` that constains 
`DBROOTPWD` and `DBVERSION` environment variables. These two variables
correspond to Mariadb root password and version (tested on 10.).

`gen_db.sh` creates necessary databases if they don't exit during database
initialization. User name and password are the same as the database name.
Modify `.db.env` to change database name.

```bash
docker-compose up -d 			# deploy gogs and nextcloud  services
docker-compose up -d gogs db 		# deploy gogs
docker-compose up -d nextcloud db	# deploy nextcloud
```

