FROM ubuntu

WORKDIR /usr/src/app

COPY . .

RUN bash -c "echo 'deb http://us.archive.ubuntu.com/ubuntu focal main restricted universe' | tee /etc/apt/sources.list; apt update"

RUN apt install -y gnupg2 curl

RUN DEBIAN_FRONTEND="noninteractive" bash ./setup.sh -a

EXPOSE 8000

CMD bash -c "source /usr/local/rvm/scripts/rvm; pg_ctlcluster 12 main start; bundle exec rails s -b 0.0.0.0"
