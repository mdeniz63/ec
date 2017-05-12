#!/bin/bash
line="00 00 * * * /bin/sh /nitro/script/backup.sh > /nitro/backups/backup.log 2>&1"
(crontab -u postgres -l; echo "$line" ) | crontab -u postgres -
