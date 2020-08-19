MITRE CTF Scoreboard
--------------------

[![Build Status](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard.svg?branch=master)](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard)
[![Code Climate](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard/badges/gpa.svg)](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard)

MITRE CTF Scoreboard is a fully featured CTF platform with scoreboard and registration application built with Ruby on Rails. It is used for MITRE Capture the Flag competition website.

### Installation

#### Development

See [wiki instructions](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Development-Installation) for creating a local development installation of the scoreboard.

#### Testing

Once you have installed the application using the development steps shown above, the tests can be run by running `bundle exec rake test`.

To generate a local code coverage report in `coverage/index.html` set the `$LOCAL_COVERAGE` environment variable: `export LOCAL_COVERAGE=true`

#### Production

Follow the [wiki instructions](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Production-Installation) for creating a production installation of the scoreboard.

### Automated Emails

Automated emails can be setup by adding the crontab:

```min hour * * * /bin/bash -l -c 'cd /path/to/ctf-scoreboard && RAILS_ENV=production bundle exec rake email:automated_email --silent'```

Where `min`, `hour`, and `path/to/ctf-scoreboard` are replaced with the values you prefer.
If the project is being hosted on Heroku a daily task can be created using the Heroku Scheduler to run `rake email:automated_email`

### Screenshots

#### Gameboard

![gameboard](https://i.imgur.com/9NkEPac.png)

#### Administration Dashboard

![admin dashboard](https://i.imgur.com/T9Fth6g.png)

#### Administration Dashboard -> Add challenge

![add challenge](https://i.imgur.com/kjkZ1pI.png)

##### More screenshots available on the [wiki](https://github.com/mitre-cyber-academy/ctf-scoreboard/wiki/Screenshots).

### License ###

This application is licensed under [Apache License 2.0](LICENSE).
