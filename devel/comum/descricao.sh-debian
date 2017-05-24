#!/bin/bash
ip=`cat /usr/local/bin/radio-update.sh | grep ip= | cut -d '"' -f2 | head -n1`
hora=`cat /usr/local/bin/radio-update.sh | grep hora= | cut -d '"' -f2`
rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
data=`date`
tempo=`uptime | cut -d "," -f1`
ip_loja=`ifconfig | grep 'inet' | cut -d ":" -f2 | head -n1 | cut -d " " -f2`
if [ -z $ip_loja  ]; then
        ip_loja=`ifconfig | grep 'inet' | cut -d ":" -f2 | head -n1 | cut -d " " -f1`
fi
mask_loja=`ifconfig | grep "inet" | head -n1 | cut -d ":" -f4`
gateway=`route -n | grep UG | head -n 1 | cut -b17- | cut -f1 -d" "`
hostname=`cat /etc/hostname`
data_sql=`stat /var/www/radio.sql | grep Modify | tail -n1 | cut -d " " -f2`
data_zip=`stat /var/www/radio.zip | grep Modify | tail -n1 | cut -d " " -f2`
updateM=`cat /etc/crontab | grep radio-update | cut -c 1-2`
updateH=`cat /etc/crontab | grep radio-update | cut -c 4-5`
sistema=`/bin/cat /etc/VERSAO`
echo "CREATE TABLE descricao (rede varchar(20), loja varchar(50), dc varchar(20), hora varchar(30), ip_loja varchar(20), mask_loja varchar(20), gateway varchar(20), hostname varchar(20), updateH varchar (3), updateM varchar(3), data_sql varchar(30), data_zip varchar(30), sistema varchar(15), tempo varchar(30) );" | mysql radio 2> /dev/null
compara=`echo "select loja from descricao" | mysql radio | tail -n1`
if [ -z $compara ]; then
        echo "insert into descricao (rede,loja,dc,hora,ip_loja,mask_loja,gateway,hostname,updateH,updateM,data_sql,data_zip,sistema,tempo) values ('','','','','','','','','','','','','','');" | mysql radio
fi
echo "update descricao set rede='$rede';" | mysql radio
echo "update descricao set loja='$loja';" | mysql radio
echo "update descricao set dc='$ip';" | mysql radio
echo "update descricao set hora='$hora';" | mysql radio
echo "update descricao set ip_loja='$ip_loja';" | mysql radio
echo "update descricao set mask_loja='$mask_loja';" | mysql radio
echo "update descricao set gateway='$gateway';" | mysql radio
echo "update descricao set hostname='$hostname';" | mysql radio
echo "update descricao set updateH='$updateH';" | mysql radio
echo "update descricao set updateM='$updateM';" | mysql radio
echo "update descricao set data_sql='$data_sql';" | mysql radio
echo "update descricao set data_zip='$data_zip';" | mysql radio
echo "update descricao set sistema='$sistema';" | mysql radio
echo "update descricao set tempo='$tempo';" | mysql radio
