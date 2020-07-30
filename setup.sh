#!/bin/bash
while [ "$1" != "" ]; do
    case $1 in
        -s | --setupdb )       setupdb=0
                                ;;
        -p | --production )    production=0
                                ;;
    esac
    shift
done

bundle install
echo

if [[ "$setupdb" == 0 ]];
then
    if [[ "$production" == 0 ]];
    then
        rails db:environment:set RAILS_ENV=production
    else
        rails db:environment:set RAILS_ENV=development
    fi
    echo "Creating tables..."
    rails db:create
    echo "Loading schema..."
    rails db:schema:load
    echo "Creating administrator user... Please fill out the credentials you want to use to login to the admin account."
    rails db:create_admin
fi