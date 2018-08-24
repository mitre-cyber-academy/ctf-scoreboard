MITRE CTF Scoreboard
--------------------

[![Build Status](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard.svg?branch=master)](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard)
[![Coverage Status](https://coveralls.io/repos/github/mitre-cyber-academy/ctf-scoreboard/badge.svg?branch=master)](https://coveralls.io/github/mitre-cyber-academy/ctf-scoreboard?branch=master)
[![Code Climate](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard/badges/gpa.svg)](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard)

MITRE CTF Scoreboard is a fully featured CTF platform with scoreboard and registration application built with Ruby on Rails. It is used for MITRE Capture the Flag competition website.

### Deployment ###

+ Install ruby.
+ In your terminal run `gem install bundler`
+ Install postgres to your system (and create a role with your system username).
+ Setup Recaptcha. This can be done by getting a site key from [here](https://www.google.com/recaptcha/intro/) and then setting the `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY` environment variables for the application. The steps for this will vary based on your hosting platform.
+ Run `bundle install`
+ Run `bundle exec rake db:create`
+ Run `bundle exec rake db:schema:load`
+ Run `bundle exec rake db:seed`
+ Run `bundle exec rails s`
+ Open the webpage shown in your terminal from the last command in your browser.
+ Login to the registration app `http://localhost:3000` as email: `root@root.com`, password: `ChangeMe123` or email: `ctf@mitre.org`, password: `Test123456` and change the password.
+ Access the administration panel at `http://localhost:3000` to configure the application.

**Note**: for specific deployment steps check the [wiki](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Installation).

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
