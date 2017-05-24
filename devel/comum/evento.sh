#!/bin/bash

#arquivo q vai tocar
arquivo1=`ls -1 /usr/local/radio/generos/comercial/zz_paoquentinho/`
arquivo="/usr/local/radio/generos/comercial/zz_paoquentinho/$arquivo1"
#arquivo temporário
temp=/tmp/pao
delay=60
agora=$(date +%s)

#verifica se arquivo existe
if [ ! -e "$temp" ]; then
  touch "$temp"
fi

#le a primeira linha do arquivo temporaio
line=$(head -1 $temp)

#verifica as condições, se a primeira linha é vazia, se é 0, se o ultimo tempo + delay é menor do q agora(caso echo 0 falhar)
if [ -z "$line" ] || (( $line==0 )) || (( $agora > $(($line+$delay)) )); then
  echo $agora > $temp

  volume=100
  #baixa volume
  while (( $volume >= 0 )); do
    ((volume=volume-10))
    echo set_property volume $volume > /tmp/playlist_in
    sleep 0.01
  done

  echo pausing_keep set_property mute 1 > /tmp/playlist_in
  echo pause > /tmp/playlist_in

  #toca arquivo - set (-o local = PS2 ou -o hdmi )
  omxplayer -o local "$arquivo"

  #sobe volume
  echo pausing_keep set_property mute 0 > /tmp/playlist_in
  echo pause > /tmp/playlist_in
  while (( $volume < 100 )); do
    ((volume=volume+10))
    echo set_property volume $volume > /tmp/playlist_in
    sleep 0.1
  done
  echo 0 > $temp
fi
