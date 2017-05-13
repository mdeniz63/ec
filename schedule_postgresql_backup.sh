#!/bin/bash
line="00 00 * * * /bin/sh /nitro/script/backup_postgresql.sh > /nitro/backups/backup_postgresql.log 2>&1"
(crontab -u postgres -l; echo "$line" ) | crontab -u postgres -
