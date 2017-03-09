# docker-cgit
Docker compose, cgit, uwsgi, proxy nginx

# Installation

Install docker-compose (virtualenv can ne used as well)

# Steps to deploy

* Update **env.config** file to meet your requirements:

```bash
# Data volume root dir
export VOLUME_PATH=/srv/cgit-data

# # will be accessable with https://WEB_SERVER_NAME
export WEB_SERVER_NAME=sandbox.example.com
export WEB_SERVER_PORT=80
```

# Running
Please check **./manage.sh** for help
```bash
Usage: ./manage.sh ACTION

 ACTION:
   init                 [Optional] generate config files,
                        build required images
   status               get containers status
   debug                run docker-compose in foreground
   start                start all containers in background
   stop                 stop all containers
```

# Usage
* Get access to cgit server with address: `http://WEB_SERVER_NAME:WEB_SERVER_PORT`
* Put your git repos to `VOLUME_PATH`

# Notes

* you can customize cgit static content from `.nginx/cgit-static`
* You need to have sudo for `mkdir` and `chown` commands, since container
runs under `cgit` user and stores data on `VOLUME_PATH`
