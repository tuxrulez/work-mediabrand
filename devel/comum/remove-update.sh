#!/bin/bash

# 2011-10-03


ls -R | grep -v adiciona-update.sh | grep -v remove-update.sh | while read arquivo 
do
	ls -R ../ | grep -v ^000 | while read loja
	do
		rm -f ../$loja/* 2> /dev/null
	done
done
