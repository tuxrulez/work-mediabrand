#!/bin/bash 
	echo "UPDATE tbl_encapsulador SET bitrate='500k' " | mysql -uroot -prapadura2 CTRL_DTCOM
	echo "select bitrate from tbl_encapsulador" | mysql -uroot -prapadura2 CTRL_DTCOM 
	echo "1M -- `date`" >> /tmp/muda.txt
