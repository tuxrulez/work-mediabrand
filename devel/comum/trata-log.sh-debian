#!/bin/bash
# feito por:
# Gildecio E Barboza
# data: 13 Abr 2016
rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
/usr/local/bin/descricao.sh
echo "delete from descricao where rede='$rede' AND loja='$loja';" > /var/log/radio/${rede}_${loja}-descricao.sql
mysqldump  --skip-triggers --compact --no-create-info radio descricao >> /var/log/radio/${rede}_${loja}-descricao.sql
mysqldump  --skip-triggers --compact --no-create-info radio audiencia > /var/log/radio/${rede}_${loja}_`date +%d%m%Y%H%S`.sql
echo "drop table descricao" | mysql radio 2> /dev/null
echo "drop table audiencia" | mysql radio 2> /dev/null
