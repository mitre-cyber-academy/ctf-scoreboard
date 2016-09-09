MITRE CTF Registration Site
---------------------------

[![Build Status](https://travis-ci.org/mitre-cyber-academy/registration-app.svg?branch=master)](https://travis-ci.org/mitre-cyber-academy/registration-app)
[![Coverage Status](https://coveralls.io/repos/github/mitre-cyber-academy/registration-app/badge.svg?branch=master)](https://coveralls.io/github/mitre-cyber-academy/registration-app?branch=master)

Rails application for registering for the MITRE Capture the Flag competition website.

### Exporting teams to the scoreboard

Exporting teams into a format that the [scoreboard](https://github.com/mitre-cyber-academy/ctf-scoreboard) understands is easy. All you have to do is run the following command. As a note, **this command WILL email all registered users the information it generates, so use it with caution!** The contents of the email it sends can be found [here](https://github.com/mitre-cyber-academy/registration-app/blob/master/app/views/user_mailer/send_credentials.html.haml).

    bundle exec rake export:players_to_scoreboard

This will spit out a large number of commands which need to be pasted into the console on the scoreboard. In order to make handling this data easier you can pipe the output into pbcopy on mac, or write it out to a file. Once you have run this command, make sure you remember to run the commands on the scoreboard, otherwise teams will not be able to login!