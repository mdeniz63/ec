#!/bin/bash 
# BACKUP ALL DB with PG_DUMPALL
# run with postgres user
# FOR Reloading use command --> gunzip -c filename.gz | psql dbname 
tarih=`date +%Y_%m_%d`
dosya="EC_PG_BACKUP-$tarih"
dizin="/nitro/backups/"
cd $dizin


start_backup(){
	pg_dumpall | gzip > $dosya.gz
	echo "Backup Finished " $tarih
}

delete_old_backups(){
	# DELETE BACKUP FILES OLDER THAN 7 days
	find $dizin* -mtime +7 -exec rm {} \;
}

if [ $USER != "postgres" ]
then
        echo "You must run with postgres user"
	exit
else
	start_backup
	delete_old_backups
fi

