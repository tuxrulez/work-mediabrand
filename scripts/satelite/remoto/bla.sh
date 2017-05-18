#!/bin/bash
PID=$(ps -eo pid,comm | awk '$2 == "rsync" {print $1 }' | sed -n '1p')
if [ "$PID" != " " ]; then
        rsync=`echo "Sincronizando Conteudo"`
else
        rsync=`echo "nao"`
fi

xx=`ps ax | grep gz | cut -d " " -f33`
PID2=$(ps -eo pid,comm | awk '$2 == "udp-sender" {print $1 }' | sed -n '1p')
if [ $xx == "-f" ]; then
        xx=`ps ax | grep gz | cut -d " " -f34`
else
        xx=`ps ax | grep gz | cut -d " " -f33`
fi
if [ $xx != " " ] ; then
        Pacote=$xx
else
        Pacote=`echo "Sem Pacote trafegando"`
fi


x=`ps ax| grep envia | grep bin`

if [ $? == 1 ]; then
        echo "fuuuuuuuuu `date`" >> /tmp/lixo.txt
        (cd /tmp; nohup /usr/local/bin/envia-pacote.sh 2> /dev/null &)
else
        echo "Funcionando `date` Pacote: $Pacote e/ou Rsync: $rsync " >> /tmp/lixo.txt
fi
chown suporte. /tmp/lixo.txt

