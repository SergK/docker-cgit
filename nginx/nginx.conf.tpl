user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    include                 mime.types;
    default_type            application/octet-stream;
    sendfile                on;
    keepalive_timeout       65;
    gzip                    on;

    server {
        listen *:{{WEB_SERVER_PORT}};
        server_name {{WEB_SERVER_NAME}};

        # We want to serve cgit static content from /usr/share/cgit and let Nginx cache it
        location ~* ^.+(cgit.(css|png)|favicon.ico|robots.txt) {
            root /usr/share/cgit;
            expires 30d;
        }

        location / {
          try_files $uri @cgit;
        }

        # Now forward everything else to our uwsgi instance
        location @cgit {
            gzip off;
            fastcgi_split_path_info ^(/cgit/?)(.+)$;
            uwsgi_param PATH_INFO $fastcgi_path_info;
            include uwsgi_params;
            uwsgi_modifier1 9;
            uwsgi_pass cgit:9000;
        }
    }

}
