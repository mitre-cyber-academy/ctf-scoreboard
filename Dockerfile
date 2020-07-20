FROM postgres

WORKDIR /usr/src/app

COPY . .

RUN bash -c "echo 'deb http://us.archive.ubuntu.com/ubuntu focal main restricted universe' | tee /etc/apt/sources.list; apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32; apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C; apt update"

RUN apt install -y gnupg2 curl procps libpq-dev

RUN DEBIAN_FRONTEND="noninteractive" bash ./setup.sh -a

EXPOSE 3000

CMD bash -c "source /usr/local/rvm/scripts/rvm; pg_ctlcluster 12 main start; bundle exec rails s -b 0.0.0.0"
