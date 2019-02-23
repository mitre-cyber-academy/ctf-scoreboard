MITRE CTF Scoreboard
--------------------

[![Build Status](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard.svg?branch=master)](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard)
[![Coverage Status](https://coveralls.io/repos/github/mitre-cyber-academy/ctf-scoreboard/badge.svg?branch=master)](https://coveralls.io/github/mitre-cyber-academy/ctf-scoreboard?branch=master)
[![Code Climate](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard/badges/gpa.svg)](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard)

MITRE CTF Scoreboard is a fully featured CTF platform with scoreboard and registration application built with Ruby on Rails. It is used for MITRE Capture the Flag competition website.

### Deployment ###

#### Development ####

+ Install ruby (using a ruby version manager like [rvm](https://rvm.io/) is recommended).
+ In your terminal run `gem install bundler`
+ Install postgres to your system (and create a role with your system username `sudo -u postgres -i` then `createuser --interactive`).
+ Setup Recaptcha. This can be done by getting a site key from [here](https://www.google.com/recaptcha/intro/) and then setting the `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY` environment variables for the application. The steps for this will vary based on your hosting platform.
+ Run `bundle install` to install dependencies
+ Run `bundle exec rake db:create` to create the database
+ Run `bundle exec rake db:schema:load` to load the database schema
+ Run `bundle exec rake db:seed` to load demo data
+ Run `bundle exec rails s` to launch the server in development mode
+ Open the webpage shown in your terminal from the last command in your browser.
+ Login to the registration app `http://localhost:3000` as email: `root@root.com`, password: `ChangeMe123` or email: `ctf@mitre.org`, password: `Test123456` and change the password.
+ Access the administration panel at `http://localhost:3000/admin` to configure the application.

**Note**: for specific deployment steps check the [wiki](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Installation).

#### Production ####

**Warning**: The most tested way of deploying the ctf-scoreboard is using Heroku, or if you want to use your own server then using https://github.com/dokku/dokku. Don't deploy this in production without a proper and secure reverse proxy.

+ Install ruby (using a ruby version manager like [rvm](https://rvm.io/) is recommended).
+ In your terminal run `gem install bundler`
+ Install postgres to your system (and create a role with your system username `sudo -u postgres -i` then `createuser --interactive`).
+ Setup Recaptcha. This can be done by getting a site key from [here](https://www.google.com/recaptcha/intro/) and then setting the `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY` environment variables for the application. The steps for this will vary based on your hosting platform.
+ Run `bundle install` to install dependencies
+ Run `bundle exec rake db:create` to create the database
+ Run `bundle exec rake db:schema:load` to load the database schema
+ Run `bundle exec rails c` to launch Rails console, then run those commands:
  - `user = User.create(email: 'your.mail@example.com', password: 'your_password', admin: true)` to create a admin user
  - validate your email address or use `user.confirm` to avoid confirmation
  - `user.save` to save the user
  - exit Rails console
+ Run `bundle exec rails s -e production` to launch the server in production mode
+ Open the webpage shown in your terminal from the last command in your browser.
+ Login to the registration app `http://localhost:3000` as the admin user you created.
+ Access the administration panel at `http://localhost:3000/admin` to configure the application.

### Automated Emails ###

Automated emails can be setup by adding
`min hour * * * /bin/bash -l -c 'cd /path/to/ctf-scoreboard && RAILS_ENV=production bundle exec rake email:automated_email --silent'`
where `min`, `hour`, and `path/to/ctf-scoreboard` are replaced with the values you prefer.
If the project is being hosted on Heroku a daily task can be created using the Heroku Scheduler to run `rake email:automated_email`

### Screenshots ###

Gameboard

![gameboard](https://i.imgur.com/UgkPX5q.png)

Administration: dashboard

![admin dashboard](https://i.imgur.com/lzj7U3m.png)

Administration: add challenge

![add challenge](https://i.imgur.com/ZRyimTp.png)

More screenshots available on the [wiki](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Screenshots).

### License ###

This application is licensed under [Apache License 2.0](LICENSE).
