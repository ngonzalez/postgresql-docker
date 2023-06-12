FROM debian:sid

# apt
ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://ftp.fr.debian.org/debian/ unstable main contrib non-free" > /etc/apt/sources.list
RUN apt-get update -yq
RUN apt-get dist-upgrade -yq
RUN apt-get upgrade -yq

# debconf
RUN apt-get install -yq debconf libreadline-dev
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg-reconfigure debconf

# USER
ARG user="postgres"
ENV USER $user
RUN echo "USER=$USER" > /etc/profile.d/user.sh
RUN useradd -m $USER -s /bin/bash
RUN apt-get install -yq sudo
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# postgresql
ARG POSTGRESQL_VERSION="14"
ENV POSTGRESQL_VERSION $POSTGRESQL_VERSION
RUN apt-get install -yqq curl gnupg2
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt sid-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update -yqq && apt-get install -yqq postgresql-$POSTGRESQL_VERSION libpq-dev
RUN echo "host  all all  0.0.0.0/0      trust" >> /etc/postgresql/$POSTGRESQL_VERSION/main/pg_hba.conf
RUN echo "host  all all  172.17.0.1/24  trust" >> /etc/postgresql/$POSTGRESQL_VERSION/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf
RUN su -c "/usr/lib/postgresql/$POSTGRESQL_VERSION/bin/initdb -D /var/lib/postgresql/$POSTGRESQL_VERSION/data" $USER

ARG postgresql_port="5432"
ENV POSTGRESQL_PORT $postgresql_port

EXPOSE $POSTGRESQL_PORT

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh", "--server"]
