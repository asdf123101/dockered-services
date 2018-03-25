This is a template for setting up gogs and/or nextcloud on a server.
Before calling `docker-compose`, change `DBROOTPWD` variable in `.env`
to your own database password and `server_name` in `nginx.conf` to your
own doamin name.

`gen_db.sh` creates necessary databases if they don't exit during database
initialization. User name and password are the same as the database name.

```bash
docker-compose up -d 			# deploy gogs and nextcloud  services
docker-compose up -d gogs db 		# deploy gogs
docker-compose up -d nextcloud db	# deploy nextcloud
```
Nextcloud and gogs are accessible on host port `8888` and `3000` during the initial
setup. To use them with nginx reverse proxy server, the webroot path of nextcloud and gogs
should be set correctly. By default, gogs will be served under `domain-name/gogs`
and nextcloud `domain-name/nextcloud`. 

- Gogs: The webroot can be changed during initial setup. Simply change the `Application URL`
to `doamin-name/gogs`. Alternatively, change `ROOT_URL` in `path-to-gogs-volume/gogs/conf/app.ini`.
- Nextcloud: Add `'overwritewebroot' => '/nextcloud'` in `path-to-nextcloud-volume/config/config.php`. In addition, set `'overwrite.cli.url'` and `'htaccess.RewriteBase'` to reflect this change. See [here](https://docs.nextcloud.com/server/9/admin_manual/configuration_server/config_sample_php_parameters.html) for more information.

The path of these services can be changed in the `location` section of `nginx.conf`. Remember
to repeat the above setup to reflect the path change.

After the initial setup and tested the services, the opened ports, `8888` and `3000` on host, can be turned to `expose`, leaving them only accessible to the reverse proxy server. The ssh port `8080`, however, should be kept only if ssh access to gos is required.
