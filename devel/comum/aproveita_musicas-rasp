#!/bin/bash

# Script que aproveita as musicas que estao sendo veiculadas como comercial e armazena num banco musical
# Salustriano Bessa <salusbessa@yahoo.com.br>
# 2011-10-19

# Variaveis de uso Global no script

path_origem="/usr/local/radio/generos/comercial"
path_destino="/usr/local/radio/generos/musical"
path_comercial="Anunciar_Musicas"
path_musical="banco_sazional"
path_time="/usr/local/bin"
rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`


#Inicio do script

cheka_diretorio=`ls ${path_destino} | grep ${path_musical}`
if [ "$cheka_diretorio" = "" ] 
then
	mkdir ${path_destino}/${path_musical}
	chmod 775 ${path_destino}/${path_musical}
	chown radiob.users ${path_destino}/${path_musical}
fi


ls ${path_origem}/${path_comercial} | sort | while read musicas
do
	echo "delete from arquivos where arquivo='$musicas';" | mysql -u root radio
	mv ${path_origem}/${path_comercial}/"$musicas" ${path_destino}/${path_musical}
done


ls ${path_destino}/${path_musical}/*mp3 | grep '$rede - 1' | while read arq
do
	nome=`echo "$arq" | sed 's/$rede - 1//g'`
	mv "$arq" "$nome"
done

chown radiob.users ${path_destino}/${path_musical}/*

# Limpa a base dados elimando os cadastros antigos de musica
echo "delete from arquivos where tipo='musical';" | mysql -u root radio
echo "delete from generos where tipo='musical';" | mysql -u root radio

# Insere as musicas no MySQL e corrige as permissoes
ls ${path_destino}/ > /tmp/banco_musical.txt

cat /tmp/banco_musical.txt | while read genero
do
	chown -R radiob. ${path_destino}/${genero}
	echo "insert into generos values ('musical', '${genero}');" | mysql -u root radio
	ls ${path_destino}/${genero}/ > /tmp/cadastra_musical.txt
	cat /tmp/cadastra_musical.txt | while read musica
	do
		tempo=`mp3info -p '%S' ${path_destino}/${genero}/"${musica}"`
		echo "insert into arquivos values ('musical', '${genero}', '${musica}', '${tempo}', '2004-01-01', '2038-12-31', '1,2,3,4,5,6,7', 0, 86399, '${rede}', '${loja}', 'Nao');" | mysql -u root radio	
	done
done
