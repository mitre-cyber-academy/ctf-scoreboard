MITRE CTF Scoreboard
--------------------

[![Build Status](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard.svg?branch=master)](https://travis-ci.org/mitre-cyber-academy/ctf-scoreboard)
[![Coverage Status](https://coveralls.io/repos/github/mitre-cyber-academy/ctf-scoreboard/badge.svg?branch=master)](https://coveralls.io/github/mitre-cyber-academy/ctf-scoreboard?branch=master)
[![Code Climate](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard/badges/gpa.svg)](https://codeclimate.com/github/mitre-cyber-academy/ctf-scoreboard)

An application for running a jeopardy-style Capture the Flag competition.

### Automated Emails ###

Automated emails can be setup by adding
`min hour * * * /bin/bash -l -c 'cd /path/to/registration-app && RAILS_ENV=production bundle exec rake email:automated_email --silent'`
where `min`, `hour`, and `path/to/registration-app` are replaced with the values you prefer. 
If the project is being hosted on Heroku a daily task can be created using the Heroku Scheduler to run `rake email:automated_email`
