FROM dokken/centos-stream-9:latest

RUN dnf install -y openssh-server
RUN ssh-keygen -A

RUN dnf install -y redis
RUN echo 'requirepass geek' >> /etc/redis/redis.conf

RUN dnf install -y mysql-server
COPY var/lib/mysql /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql
RUN mkdir -p /var/lib/sjx/images/avatar

RUN dnf install -y java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless
COPY data /data

RUN dnf clean all

RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/sshd' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/libexec/mysqld --basedir=/usr --user=mysql &' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/sysctl vm.overcommit_memory=1 && /usr/bin/redis-server /etc/redis/redis.conf &' >> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/bin/java -Dspring.config.location=/data/application.properties -jar /data/sjx-0.0.1.jar &' >> /usr/local/bin/docker-entrypoint.sh
RUN echo 'while true; do sleep 100; done;' >> /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 22 8080
