#!/bin/bash 
	echo "UPDATE tbl_encapsulador SET bitrate='2000K' " | mysql -uroot -prapadura2 CTRL_TRANSMISSOES
	echo "select bitrate from tbl_encapsulador" | mysql -uroot -prapadura2 CTRL_TRANSMISSOES 
	echo "2M -- `date`" >> /tmp/muda.txt
