# FingerlessGlov3s' Tiny Tiny RSS container

This is a simple docker container to deploy [Tiny Tiny RSS](https://tt-rss.org/) as a container, only tested with mysql(mariadb) backend.

My instructions assume you use the path `/docker` for your docker containers.

1. Install Docker [Link](https://docs.docker.com/engine/install/)
1. Install Docker Compose [Link](https://docs.docker.com/compose/install/)
1. Install Git [Link](https://github.com/git-guides/install-git#install-git-on-linux)
1. Use the following commands to create the folder structure
    ```
    mkdir -p /docker/ttrss/plugins.local/
    mkdir -p /docker/ttrss/build/
    ```
1. Clone this repo in to build folder `git clone https://github.com/FingerlessGlov3s/ttrss-docker /docker/ttrss/build`
1. Clone SMTP mailer (optional) `git clone https://git.tt-rss.org/fox/ttrss-mailer-smtp /docker/ttrss/plugins.local/mailer_smtp`
1. Now we need to create our docker-compose file `/docker/docker-compose.yaml` using the example below. You'll need to provide your own mysql and smtp details. If you don't already have a mysql server/container, you can use the offical mariadb container [here](https://hub.docker.com/_/mariadb) example is provided below. Remove the SMTP related environment variables if you didn't install the mailer plugin in step 2. Make sure to change the passwords.
    ```yaml
    version: "2"

    services:
      ttrss:
        build:
          context: /docker/ttrss/build/
          dockerfile: Dockerfile
        container_name: ttrss
        hostname: ttrss
        restart: always
        depends_on:
          - mariadb
        environment:
          - TTRSS_DB_TYPE=mysql
          - TTRSS_DB_HOST=mariadb
          - TTRSS_DB_PORT=3306
          - TTRSS_DB_NAME=ttrss
          - TTRSS_DB_USER=ttrss
          - TTRSS_DB_PASS=HCQctvJfU6LZJwQS9zz9BUd8Ai93pu95SS8HBjFk
          - TTRSS_SELF_URL_PATH=http://hostip
          - TTRSS_PLUGINS=auth_internal,mailer_smtp
          - TTRSS_SMTP_SERVER=smtp.gmail.com:587
          - TTRSS_SMTP_SECURE=tls
          - TTRSS_SMTP_FROM_ADDRESS=MYRSSReader69@gmail.com
          - TTRSS_SMTP_FROM_NAME=Tiny Tiny RSS
          - TTRSS_SMTP_LOGIN=MYRSSReader69@gmail.com
          - TTRSS_SMTP_PASSWORD=AppPassword
        volumes:
          - /docker/ttrss/plugins.local:/var/www/html/plugins.local
        ports:
          - 80:80

      mariadb:
        image: mariadb
        container_name: mariadb
        hostname: mariadb
        restart: always
        environment:
          - MARIADB_ROOT_PASSWORD=mM3oa4cQ8RqKD28mfEydPZAB3QnoWRCtomoxCy7f
          - MARIADB_DATABASE=ttrss
          - MARIADB_USER=ttrss
          - MARIADB_PASSWORD=HCQctvJfU6LZJwQS9zz9BUd8Ai93pu95SS8HBjFk
        volumes:
          - /docker/mariadb:/var/lib/mysql
    ```
1. Build and start the container `docker-compose build ttrss && docker-compose up -d` with your current directory as `/docker/`
1. It'll take a moment to start and then you can go to container's URL. Default login is admin/password