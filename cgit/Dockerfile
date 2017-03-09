FROM debian:jessie

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cgit \
    git \
    highlight \
    uwsgi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -r -u 900 -m -c "cgit role account" -d /home/cgit -s /bin/false cgit

COPY cgitrc /etc/cgitrc

COPY cgit-syntax-highlighting.sh /usr/lib/cgit/filters/cgit-syntax-highlighting.sh

COPY cgit.ini /etc/uwsgi/apps-available/cgit.ini

USER cgit

CMD /usr/bin/uwsgi --ini /etc/uwsgi/apps-available/cgit.ini
