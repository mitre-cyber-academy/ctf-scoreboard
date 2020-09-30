FROM ruby:2.7

WORKDIR /usr/src/app

ENV RAILS_ENV=production

COPY Gemfile Gemfile.lock ./

RUN apt update

RUN apt install -y libpq-dev

RUN bundle config set without 'development test'; bundle install

COPY . .

RUN SECRET_KEY_BASE=precompile bundle exec rake assets:precompile

EXPOSE 3000

CMD bash -c "bundle exec rails s -b 0.0.0.0"
