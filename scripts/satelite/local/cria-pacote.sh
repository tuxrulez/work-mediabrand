#!/bin/bash
#
# Cria pacote envia para envio Satelite
#
#
usuario="suporte"
senha="rapaduraX"
ipservidor="10.0.1.226"
data=`date +%Y%m%d%H%M%S`
data_mysql=`date "+%Y-%m-%d %H:%M:%S"`
dir_cliente="/local/tv/$1"
dir_pacote_temp="/tmp/$1"
dir_pacotes="/local/pacotes/$1"

testa_rede=`echo "SELECT cod_cliente FROM tbl_clientes WHERE rede_cliente=\"$1\"" | mysql -u${usuario} -p${senha} CTRL_TRANSMISSOES | grep -v cod_cliente`


if [ "$testa_rede" != "" ]
then
	#Compara os diretorios Origem e Destino e gera um arquivo txt com a diferenca.
	/usr/bin/rsync -av --timeout=180 --delete-after --password-file=/etc/tv.update rsync://$1@$ipservidor:/$1/ $dir_cliente > $dir_pacotes/conteudo_pacote_rsync_${1}_${data}.txt

	#limpa dados desnecessarios
	cat $dir_pacotes/conteudo_pacote_rsync_${1}_${data}.txt | grep -v "building" | grep -v "sent" | grep -v "total" | grep -v "receiving" | grep -v "^deleting" | sed '/^$/d' | tail -n +8 > $dir_pacotes/conteudo_pacote_${1}_${data}.txt

	arq_limpo=`cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt`

	if [ "$arq_limpo" != "" ]
	then
		#deleta se existir e cria novo esqueleto de diretorios
		if [ -d $dir_pacote_temp ]
		then
			rm -rf  $dir_pacote_temp
		fi

		#fase 1
		cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep \/$ | while read i; 
		do 
			mkdir -p $dir_pacote_temp/$i	
		done

		#fase 2 --> generos
		mkdir -p $dir_pacote_temp/generos/000
		
		cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | cut -d"/" -f3 | grep ^[A-Z] | grep -v tv.zip | while read i; 
		do
			mkdir -p $dir_pacote_temp/generos/000/$i
		done


		sed -n 's/->\ ..\/..\//,/p' $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^generos | while read i; 
		do  
			target=`echo "$i" | cut -d',' -f 2`; 

			esqueleto=`echo "$i" | cut -d',' -f 1 | sed 's/\ $//'`;

			cp -rf "$dir_cliente/generos/$target" "$dir_pacote_temp/generos/$target" 	
#			cp -l "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"
			cp -a "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"

		done

		#imagem
		mkdir -p $dir_pacote_temp/imagem/000

		sed -n 's/->\ ..\/..\//,/p' $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^imagem | while read i; 
		do  
			target=`echo "$i" | cut -d',' -f 2`; 
			esqueleto=`echo "$i" | cut -d',' -f 1 | sed 's/\ $//'`;
			
			cp -rf "$dir_cliente/imagem/$target" "$dir_pacote_temp/imagem/$target"  
#			cp -l "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"
			cp -a "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"
		done


		#scripts
		mkdir -p $dir_pacote_temp/scripts/000

		#cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^scripts | grep -v "\/$"  | while read i; 
		#cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^scripts | while read i; 
		
		sed -n 's/->\ ..\//,/p' $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^scripts | while read i; 
		do  
			#cp -rf "$dir_cliente/$i" "$dir_pacote_temp/$i"
 
			target=`echo "$i" | cut -d',' -f 2`; 
			esqueleto=`echo "$i" | cut -d',' -f 1 | sed 's/\ $//'`;

			cp -rf "$dir_cliente/scripts/$target" "$dir_pacote_temp/scripts/$target"  
#			cp -l "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"
			cp -a "$dir_cliente/$esqueleto" "$dir_pacote_temp/$esqueleto"
		done


		#sql
		mkdir -p $dir_pacote_temp/sql/000

		cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^sql | grep -v "\/$"  | while read i; 
		do  
			cp -rf "$dir_cliente/$i" "$dir_pacote_temp/$i" 
		done

		

		#gera lista de lojas que deverao receber o pacote
		cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^sql | grep zip$ | sed 's/sql\///' | sed 's/\/tv.zip//' >  $dir_pacotes/lojas_${1}_${data}.txt

		valor_lojas=`cat $dir_pacotes/lojas_${1}_${data}.txt`

		if [ "$valor_lojas" = "" ]
		then
			cat $dir_pacotes/conteudo_pacote_${1}_${data}.txt | grep ^scripts | grep \/$ | sed 's/scripts\///' | sed 's/\///' > $dir_pacotes/lojas_${1}_${data}.txt
		fi

		#compacta para envio
		cd /tmp
		tar -czf ${1}_${data}_update.tar.gz $1
		 

		#obtem codigo do cliente para cadastro de sequencia de pacotes
		cod_cliente=`echo "SELECT cod_cliente FROM tbl_clientes WHERE rede_cliente=\"$1\"" | mysql -u${usuario} -p${senha} CTRL_TRANSMISSOES | grep -v cod_cliente`

		#obtem valor da ultima sequencia para o codigo da rede do cliente
		sequencia=`echo "SELECT sequencia FROM tbl_seq_pacotes WHERE cod_cliente=\"$cod_cliente\"" | mysql -u${usuario} -p${senha} CTRL_TRANSMISSOES | grep -v sequencia`

		#soma 1 na sequencia dos pacotes (novo pacote)
		sequencia=$((sequencia+1))

		#insere no banco a nova seqquencia do pacote
		echo "UPDATE tbl_seq_pacotes SET sequencia=\"$sequencia\" WHERE cod_cliente=\"$cod_cliente\"" | mysql -u${usuario} -p${senha} CTRL_TRANSMISSOES

		#nome pacote
		nome_pacote="${1}_${data}_update.tar.gz"

		#obtem o tamanho em kbytes do pacote
		tamanho_pacote=`du ${1}_${data}_update.tar.gz | cut -f 1`

		#insere no banco, dados do pacote gerado
		echo "INSERT INTO tbl_pacotes (cod_cliente,seq_pacote,tarja_pacote,nome_pacote,tamanho_pacote,dt_hora_criacao,status) VALUES (\"$cod_cliente\",\"$sequencia\",\"$data\",\"$nome_pacote\",\"$tamanho_pacote\",\"$data_mysql\",1)" | mysql -u${usuario} -p${senha} CTRL_TRANSMISSOES

		#move para o diretorio de pacotes prontos
		mv ${1}_${data}_update.tar.gz $dir_pacotes

		#libera espaco dos temporarios
		rm -rf ${1}_${data}_update.tar.gz

		sleep 2
	fi
fi
