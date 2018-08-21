### Lets Encrypt Example
For simplicity a docker-compose.yml file is provided, as well as configuration for Nginx as a reverse proxy, with the following features:

* Nginx as a reverse proxy
* Redirect from port 80 (http) to port 433 (https)
* Automatic SSL certificates from [Let's Encrypt](https://letsencrypt.org/)
* A cron that updates daily the NVTs

To run:

* Change "example.com" in the following files:
  * [examples/letsencrypt/docker-compose.yml](docker-compose.yml)
  * [examples/letsencrypt/conf/nginx.conf](conf/nginx.conf)
  * [examples/letsencrypt/conf/nginx_ssl.conf](conf/nginx_ssl.conf)
* Change the "OV_PASSWORD" enviromental variable in [examples/letsencrypt/docker-compose.yml](docker-compose.yml)
* Install the latest [docker-compose](https://docs.docker.com/compose/install/)
* run `docker-compose up -d`
