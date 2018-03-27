## Quick start
This is a template for setting up gogs and/or nextcloud on a server and 
it assumes a docker volumn with ssl certificates is present. If you don't
have one, use following commands to obtain certificates from
Let's Encrypt.
```bash
docker column create nginx-certs
docker run -it --rm --name certbot \
-v nginx-certs:/etc/letsencrypt \
-v $SITE_LOCATION:/data/letsencrypt \
certbot/certbot certonly --webroot -w=/data/letsencrypt \
-d example.com -m example@example.com
```
`$SITE_LOCATION` is the path to your website that is served on this machine.
If you have other valid ssl certificates, simply copy them to 
`/paht-to-certs-volumn/live/${DOMAINNAME}/` and edit `nginx.conf` to use
your private key and certificate.

For enhanced security, change `DBROOTPWD` in `.env`
to your favourite password and `DOMAIN` in `docker-compose.yml` to your
own doamin name.

You can then call `docker-comose up -d` to spin up all the services.

## Additional customizations
- `gen_db.sh` creates necessary databases, i.e., `gogs` and `nextcloud` if they don't exit during database
initialization. User name and password are the same as the database name.
You can edit this script to customize your database settings.

- Services can be called individually:
```bash
docker-compose up -d 			# deploy gogs and nextcloud services
docker-compose up -d gogs		# deploy gogs
docker-compose up -d nextcloudb		# deploy nextcloud
```

- Nextcloud and gogs are accessible on host port `8888` and `3000` during initial
setup. To use them with nginx reverse proxy server, the webroot path of nextcloud and gogs
should be set correctly. By default, gogs will be served under `domain-name/gogs`
and nextcloud `domain-name/nextcloud`. 

  - Gogs: The webroot can be customized during initial setup. Simply change the `Application URL`
to `doamin-name/gogs`. Alternatively, change `ROOT_URL` in `/path-to-gogs-volume/gogs/conf/app.ini`.
You can also edit this file to further customized Gogs to your own need.
  - Nextcloud: Add `'overwritewebroot' => '/nextcloud'` in `/path-to-nextcloud-volume/config/config.php`. In addition, set `'overwrite.cli.url'` and `'htaccess.RewriteBase'` to reflect this change. See [here](https://docs.nextcloud.com/server/9/admin_manual/configuration_server/config_sample_php_parameters.html) for more information.

 The path of these services under your domain can be changed in the `location` section of `nginx.conf`. Remember
to repeat the above steps to reflect path change.

- After the initial setup and evaluating, the opened ports, `8888` and `3000` on host, can be turned to `expose`, leaving them only accessible to the reverse proxy server. The ssh port `8080`, however, should be kept if ssh access to Gogs is required.

- To enable Redis caching in Nextcloud, add following lines to `config.php`:
```
'memcache.local' => '\OC\Memcache\Redis',
'memcache.locking' => '\OC\Memcache\Redis',
'redis' => array(
	'host' => 'redis',
	'port' => 6379,
)
```
