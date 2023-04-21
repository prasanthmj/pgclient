#!/bin/bash

set -e

if [ -z "$1" ]
then
      echo "No arguments"
      exit 1
fi

NEW_DB=$1

RAND1=$(cat /dev/urandom | tr -dc '[:lower:]' | fold -w 6 | head -n 1)

NEW_DB_USER="${NEW_DB}usr${RAND1}"

RAND2=$(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w 20 | head -n 1)
RAND3=$(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w 20 | head -n 1)
NEW_DB_PASS="${RAND2}${RAND3}"


psql  << SQL
 CREATE USER $NEW_DB_USER WITH PASSWORD '$NEW_DB_PASS';
 
 CREATE DATABASE "$NEW_DB"
    ENCODING 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;
    
 grant all privileges on database $NEW_DB to $NEW_DB_USER;
SQL


cat <<EOT

New Database and user created!

DB: ${NEW_DB}
User: ${NEW_DB_USER}
Pass: ${NEW_DB_PASS}


EOT