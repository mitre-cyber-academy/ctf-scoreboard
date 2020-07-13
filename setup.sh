#!/bin/bash

postgresDownloadLink="https://get.enterprisedb.com/postgresql/postgresql-10.13-1-linux-x64.run"
postgresOutfile="postgres.run"

rubyversion=`cat .ruby-version`
rvmDownloadLink="https://get.rvm.io"


# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null
then
    # Ask the user if they want to install RVM and setup bundler
    read -p "PostgreSQL could not be found. Would you like to install PostgreSQL now? (This will run the bash script at get.rvm.io) [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Install PostgreSQL
        if ! [ -f ./$outputfile ]; then
            curl $postgresDownloadLink --output $postgresOutfile
        fi
        chmod +x ./$postgresOutfile
        sudo ./postgres.run --mode unattended --unattendedmodeui none --superaccount $USER
        export PATH=$PATH:/opt/PostgreSQL/10/bin
    else
        echo "Unable to find PostgreSQL installation because it is not installed or psql is not in path."
        exit
    fi
fi

# Check if bundler is installed
if ! command -v bundle &> /dev/null
then
    # Ask the user if they want to install RVM and setup bundler
    read -p "Ruby bundler could not be found. Would you like to install RVM now? (This will run the bash script at get.rvm.io) [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Install bundler
        gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        curl -sSL $rvmDownloadLink | bash -s stable --ruby &> /dev/null
        source $HOME/.rvm/scripts/rvm
        rvm install $rubyversion
    else
        echo "Unable to find ruby installation because it is not installed or not in path. Please ensure that bundler is in your \$PATH or that you have loaded RVM."
        exit
    fi
fi

bundle install

read -p "Would you like to load the database now? (THIS WILL DESTROY ANY DATA IN THE DATABASE) [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating tables..."
    rails db:create
    echo "Loading schema..."
    rails db:schema:load
    echo "Creating administrator user... Please fill out the credentials you want to use to login to the admin account."
    rails db:create_admin
fi

#sudo apt install ~/Downloads/GitHubDesktop-linux-2.5.3-linux1.deb
#curl -sSL https://get.rvm.io | bash -s stable --ruby
#source /home/user/.rvm/scripts/rvm
#cd Documents/ctf-scoreboard/
#sudo -i -u postgres createuser -s user
#rails db:create db:schema:load
