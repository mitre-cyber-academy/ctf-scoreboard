FROM ruby:2.7

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bash -c "echo 'deb http://us.archive.ubuntu.com/ubuntu focal main restricted universe' | tee /etc/apt/sources.list; apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32; apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C; apt update"

RUN apt install -y libpq-dev

RUN bundle install

COPY . .

EXPOSE 3000

CMD bash -c "bundle exec rails s -b 0.0.0.0"
