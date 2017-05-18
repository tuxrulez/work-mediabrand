#!/bin/bash

# Sincroniza os dados que serao transmitidos pelo satelite com o servidor de producao
# Salustriano Bessa <salusbessa@yahoo.com.br>
# 2012-05-24

# Variaveis de uso global
clientes="/root"
ip="131.255.239.38"
pacotes="/home/pacotes"
user="radiob"

# Monta a lista de clientes
## Se um cliente novo for criado, mkdir /home/pacotes/CLIENTE

ls -1 ${pacotes}/ | sort > ${clientes}/lista_clientes.txt

# Realiza o sincronismo do conteudo dos clientes
cat ${clientes}/lista_clientes.txt | while read cliente
do
        verifica=`ps ax | grep rsync | grep ${cliente}`
        if [ "${verifica}" == "" ]
        then
                /usr/bin/rsync -av --timeout=180 --delete-after --password-file=/etc/atualiza.update rsync://${user}@${ip}:874/pacotes/${cliente}/ ${pacotes}/${cliente} >> /var/log/sync_pacotes.log &
        fi
done
