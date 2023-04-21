#!/bin/bash

set -e

if [ -z "$1" ]
then
      echo "No arguments"
      exit 1
fi

export S3_REMOTE="s3remote"


# Function to backup a single database
backup_single_database() {
    DB_NAME="$1"
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    BACKUP_FILE="backup_${DB_NAME}_${TIMESTAMP}.sql.gz"

    # Take a backup of the PostgreSQL database using pg_dump
    pg_dump --dbname="${DB_NAME}" --file="${BACKUP_FILE}" --format=custom --compress=9

    # Upload the backup file to the remote S3 bucket using rclone
    rclone copy "${BACKUP_FILE}"  "${S3_REMOTE}:${S3_BUCKET}"

    # Remove the local backup file
    rm "${BACKUP_FILE}"

    echo "Backup of '${DB_NAME}' completed and uploaded to S3 bucket '${S3_BUCKET}' at $(date)"
}

# Configure the rclone S3 remote
if ! rclone listremotes | grep -q "^${S3_REMOTE}:$"; then
  echo "Configuring the ${S3_REMOTE} remote with rclone..."
  rclone config create "${S3_REMOTE}" s3 provider AWS 
  echo "${S3_REMOTE} remote configured."
fi

if [[ "$1" == "--all" ]]; then
    # Backup all databases
    databases=$(psql --host="${DB_HOST}" --port="${DB_PORT}" --username="${DB_USER}" --tuples-only --command="SELECT datname FROM pg_database WHERE datistemplate = false;")
    for db in $databases; do
        backup_single_database "$db"
    done
else
    # Backup the specified database
    if [[ -z "$1" ]]; then
        echo "Error: Please provide a database name or use --all to backup all databases."
        exit 1
    fi

    backup_single_database "$1"
fi


