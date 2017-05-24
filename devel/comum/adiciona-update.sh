#!/bin/bash

# 2011-10-03

cp -a ../../../comum/* .

ls | grep -v adiciona-update.sh | grep -v remove-update.sh | while read arquivo 
do
	ls ../ | grep -v ^000 | while read loja
	do
		#echo "criaria-se o link do arquivo $arquivo na $loja"
		ln -s "../000/$arquivo" "../$loja/$arquivo"
	done
done
