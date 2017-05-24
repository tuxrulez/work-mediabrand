#!/bin/bash
# feito por:
# Gildecio E Barboza
# data: 30 Mar 2016
rede=`cat /var/www/config.inc.php | grep "rede" | cut -d "'" -f2`
loja=`cat /var/www/config.inc.php | grep "loja" | cut -d "'" -f2`
file="/var/log/radio/executadas.txt"

echo "CREATE TABLE audiencia (rede varchar(20), loja varchar(50), data varchar(30), hora_inicio varchar(30) ,arquivo varchar(100), tipo varchar(20), genero varchar(30) );" | mysql radio 2> /dev/null

cat $file | while read line
        do
        filename="${line}"
        data=`echo $filename | cut -d "|" -f3 `
        hora=`echo $filename | cut -d "|" -f4`
        midia=`echo $filename | cut -d "|" -f5 `
        tipo=`echo $filename | cut -d "|" -f6`
	genero=`echo $filename | cut -d "|" -f7`

	echo "insert into audiencia (rede,loja,data,hora_inicio,arquivo,tipo,genero) values ('$rede','$loja','$data','$hora','$midia','$tipo','$genero'); " | mysql radio
	rm -f $file
done
