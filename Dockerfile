FROM dokken/centos-stream-9:latest

RUN dnf install -y  dnf-plugins-core
RUN dnf config-manager --set-enabled crb
RUN dnf install -y epel-release epel-next-release

RUN dnf install -y pwgen

RUN dnf install -y redis mysql-server

COPY var/lib/mysql /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql

RUN dnf install -y java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless


RUN dnf clean all

RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh

RUN echo '/usr/libexec/mysqld --basedir=/usr --user=mysql' >> /usr/local/bin/docker-entrypoint.sh

# RUN echo 'redis' >> /usr/local/bin/docker-entrypoint.sh
# RUN echo 'java' >> /usr/local/bin/docker-entrypoint.sh

RUN echo 'while true; do sleep 100; done;' >> /usr/local/bin/docker-entrypoint.sh

RUN cat /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 8080
