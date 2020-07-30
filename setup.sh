#!/bin/bash
while [ "$1" != "" ]; do
    case $1 in
        -s | --setupdb )       setupdb=0
                                ;;
    esac
    shift
done

if [[ "$setupdb" == 0 ]];
then
    rails db:environment:set RAILS_ENV=production
    echo "Setting up database..."
    rails db:initial_setup
fi