# FingerlessGlov3s' TinyTiny RSS container

This is a simple docker container to deploy [TinyTiny RSS](https://tt-rss.org/) as a container, only tested with mysql(mariadb) backend.

My instructions assume you use the path /docker for your docker containers.

1. Install Docker [Link](https://docs.docker.com/engine/install/)
1. Install Docker Compose [Link](https://docs.docker.com/compose/install/)
1. Install Git [Link](https://github.com/git-guides/install-git#install-git-on-linux)
1. Use the following commands to create the folder structure
    ```
    mkdir -p /docker/ttrss/plugins.local/
    mkdir -p /docker/ttrss/build/
    ```
1. Clone this repo in to build folder `git clone https://github.com/FingerlessGlov3s/ttrss-docker /docker/ttrss/build`
1. Clone SMTP mailer `git clone https://git.tt-rss.org/fox/ttrss-mailer-smtp /docker/ttrss/plugins.local/mailer_smtp`
1. Now we need to create our docker-compose file `/docker/docker-compose` using the example below. You'll need to provide your own mysql and smtp details
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
        environment:
          TTRSS_DB_TYPE: mysql
          TTRSS_DB_HOST: mariadb
          TTRSS_DB_PORT: 3306
          TTRSS_DB_NAME: ttrss
          TTRSS_DB_USER: ttrss
          TTRSS_DB_PASS: ttrsspassword
          TTRSS_SELF_URL_PATH: http://rss.mydomain.com
          TTRSS_PLUGINS: auth_internal,mailer_smtp
          TTRSS_SMTP_SERVER: mx.mydomain.com:587
          TTRSS_SMTP_SECURE: tls
          TTRSS_SMTP_FROM_ADDRESS: rss@mydomain.com
          TTRSS_SMTP_FROM_NAME: TinyTiny RSS
        volumes:
          - /docker/ttrss/plugins.local:/var/www/html/plugins.local
        expose:
          - 80:80
    ```
1. Build and start the container `docker-compose build ttrss && docker-compose up -d ttrss` with your current directory as `/docker/`
1. It'll take a moment to start and then you can go to container's URL. Default login is admin/password