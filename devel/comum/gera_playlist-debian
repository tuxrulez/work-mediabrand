#!/bin/bash
pkill php
pkill mplayer
> /var/www/nohup.out
echo 'delete from arquivos; delete from esquemas; delete from generos; delete from grades; delete from playlists; delete from programacoes;' | mysql radio
(cd /var/www/; nohup ./update.php; nohup ./musical.php ; sleep 5; nohup ./player.php &)
sleep 10
(cd /tmp; rm -f *)
(cd /var/log;  find .  *.gz -exec rm -f {} \;)
find /var/log/temp_audiencia -name "*.zip" -mtime +4 -exec rm -rfv {} \;
rm -f /var/www/nohup.out
reboot
