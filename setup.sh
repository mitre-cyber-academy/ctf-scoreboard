#!/bin/bash

postgresDownloadLink="https://get.enterprisedb.com/postgresql/postgresql-10.13-1-linux-x64.run"
postgresOutfile="postgres.run"

keyserver="hkp://pool.sks-keyservers.net"
rvmkeys="409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"

rubyversion=`cat .ruby-version`
rvmDownloadLink="https://get.rvm.io"

interactive=1

while [ "$1" != "" ]; do
    case $1 in
        -a | --unattended )    interactive=0
                                ;;
    esac
    shift
done

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null
then
    # Ask the user if they want to install RVM and setup bundler
    if [[ "$interactive" == 1 ]]; then
        read -p "PostgreSQL could not be found. Would you like to install PostgreSQL now? [Y/n] " -n 1 -r
    else
        REPLY="y"
    fi
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Install PostgreSQL
        # TODO: Add support for more package managers
        if ! command -v psql &> /dev/null
        then
            sudo apt install -y postgresql libpq-dev
        else
            echo "Sorry, but I don't know your package manager. Please install postgresql on your own."
            exit
        fi
    else
        echo "Unable to find PostgreSQL installation because it is not installed or psql is not in path."
        exit
    fi
fi

# Check if bundler is installed
if ! command -v bundle &> /dev/null
then
    # Ask the user if they want to install RVM and setup bundler
    if [[ "$interactive" == 1 ]]; then
        read -p "Ruby bundler could not be found. Would you like to install RVM now? (This will run the bash script at get.rvm.io) [Y/n] " -n 1 -r
    else
        REPLY="y"
    fi
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Install bundler
        gpg2 --keyserver $keyserver --recv-keys $rvmkeys
        curl -sSL $rvmDownloadLink | bash -s stable --ruby &> /dev/null
        source $HOME/.rvm/scripts/rvm
        rvm install $rubyversion
    else
        echo "Unable to find ruby installation because it is not installed or not in path. Please ensure that bundler is in your \$PATH or that you have loaded RVM."
        exit
    fi
fi

bundle install

if [[ "$interactive" == 1 ]];
then
    read -p "Would you like to load the database now? (THIS WILL DESTROY ANY DATA IN THE DATABASE) [Y/n] " -n 1 -r
else
    REPLY="y"
fi
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating role for $USER"
    sudo -u postgres createuser -s $USER
    echo "Creating tables..."
    rails db:create
    echo "Loading schema..."
    rails db:schema:load
    
    if [[ "$interactive" == 1 ]];
    then
        echo "Creating administrator user... Please fill out the credentials you want to use to login to the admin account."
        read -p "Would you like to load the database now? (THIS WILL DESTROY ANY DATA IN THE DATABASE) [Y/n] " -n 1 -r
        rails db:create_admin
    else
        echo "Creating administrator user..."
        rails db:create_admin NAME="Administrator" EMAIL="admin@admin.com" PASS="ChangeMe123"
    fi
fi