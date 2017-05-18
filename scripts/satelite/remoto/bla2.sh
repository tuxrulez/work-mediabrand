#!/bin/bash
y=`ps ax | grep rsync | grep -v grep| cut -d "-" -f4 | head -n1 | cut -d "=" -f2`
if [ "$y" == 180 ]; then
        rsync=`echo "Sincronizando Conteudo"`
else
        rsync=`echo "nao"`
fi

xx=`ps ax | grep gz | cut -d " " -f33`
#if [ $xx == "\-f" ]; then
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

