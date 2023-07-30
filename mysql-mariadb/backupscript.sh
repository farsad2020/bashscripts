#!/bin/bash
# Put a date in the file name
DATE=$(date +"%Y-%m-%d-%H:00")

# Backup Folder
BACKUP_DIR="/home/bugloos/backups"

# MySQL username/password
MYSQL_USER="root"
MYSQL_PASSWORD="mdwrsgrppeazdlko"

# MySQL commands needed to make the backup
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

# MySQL databases you want to ignore
SKIPDATABASES="information_schema|performance_schema|mysql|database1|database2"

# Data retention (days to keep backups)
RETENTION=5

# Create a new folder with today's date
mkdir -p $BACKUP_DIR/$DATE

# List all databases.
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Copy the separate databases and make a gzip file for each database.
for db in $databases; do
echo $db
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --events --databases $db | gzip > "$BACKUP_DIR/$DATE/$db.sql.gz"
done

# Delete files older than your RETENTION date
find $BACKUP_DIR/* -mtime +$RETENTION -delete
