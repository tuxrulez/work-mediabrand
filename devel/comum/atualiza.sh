#!/bin/bash


echo "VERSAO=00001" > /home/radiob/VERSAO
date  > /home/radiob/scripts-atualiza

VERSAO=`cat /etc/VERSAO` 
############# VERSAO RASPBERRY INICIO

if [ $VERSAO == "raspberry" ]; then
executa=1 
updateNOVO="22ABRIL2016" 
if [ ! -d /usr/share/${updateNOVO} -a $executa -eq 1 ]; then 
       	(cd /usr/src/; rm -rf update*) 
	(cd /tmp; rm -rf update*)
       	mkdir /usr/share/${updateNOVO} 
fi 
executa=0 

executa=1
updateNOVO="update22ABRIL-001"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
                rm -f /usr/bin/rede
                rm -f /usr/local/bin/trata-hd.sh
                rm -f /usr/local/bin/menu.sh
                rm -f /usr/local/bin/trata.sh
                rm -f /usr/local/bin/logs_hora.sh
		rm -f /usr/local/bin/trata-log.sh
		rm -f /usr/local/bin/trata-log.sh
		rm -f /usr/local/bin/descricao.sh
		#rm -f /var/www/playlist.php
		cp -a /usr/local/scripts/css2.css /var/www/locucao/css/css2.css
		cp -a /usr/local/scripts/app.js	/var/www/locucao/js/app.js
		cp -a /usr/local/scripts/oferta.php-routes /var/www/locucao/routes/oferta.php
		cp -a /usr/local/scripts/oferta.php-templates /var/www/locucao/templates/oferta.php
                cp -a /usr/local/scripts/aproveita_musicas-rasp /usr/local/bin/aproveita_musicas.sh
                cp -a /usr/local/scripts/gera_playlist-rasp /usr/local/bin/gera_playlist.sh
		cp -a /usr/local/scripts/limpa-log-rasp /usr/local/bin/limpa-log.sh
                cp -a /usr/local/scripts/radio-update.body-rasp /usr/local/etc/radio-update.body
                cp -a /usr/local/scripts/rede-rasp /usr/bin/rede.sh
                cp -a /usr/local/scripts/setup-rasp /usr/local/bin/setup.sh
		cp -a /usr/local/scripts/screenrc /root/.screenrc
		cp -a /usr/local/scripts/tabela-outros /usr/local/bin/tabela
		cp -a /usr/local/scripts/volume_menos.php /var/www/volume_menos.php
		#cp -a /usr/local/scripts/playlist.php-debian /var/www/playlist.php
		cp -a /usr/local/scripts/tocadas.sh-debian /usr/local/bin/tocadas.sh
		cp -a /usr/local/scripts/trata-log.sh-debian /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/trata-log.sh-debian /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/descricao.sh-debian /usr/local/bin/descricao.sh
		chmod 775 /usr/local/bin/trata-log.sh
		chmod 775 /usr/local/bin/tocadas.sh 
		chmod 775 /usr/local/bin/trata-log.sh
                mkdir /usr/src/${updateNOVO}
        fi
executa=0

executa=1
updateNOVO="update04JULHO2016-002"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
		## Loja x Musical - Inicial
		rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
		if [ $rede == "Shopping" ]; then
		loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
			if [ $loja == "Bourbon_Sao_Leopoldo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Sao_Leopoldo-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Novo_Hamburgo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Novo_Hamburgo-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Centerlar" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Centerlar-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Praia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Praia-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Mag" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Mag-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Pompeia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Pompeia-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Tartine" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Tartine-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Wallig" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Wallig-debian /usr/local/bin/radio-musical.sh
			fi
		else
                	cp -a /usr/local/scripts/radio-musical-rasp /usr/local/bin/radio-musical.sh
		fi
                cp -a /usr/local/scripts/checa_ip2 /usr/local/bin/checa_ip
                cp /usr/local/scripts/lista.txt /tmp/lista.txt
                cat /tmp/lista.txt | while read arquivo
       		do
                	find /usr/local/radio/generos/musical/ -iname "*${arquivo}*" -exec rm -f {} \;
                	echo "delete from arquivos where arquivo like '%${arquivo}%' and tipo='musical';" | mysql -u root radio
        	done
        fi

executa=0

executa=1
updateNOVO="update22ABRIL-003"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
		if [ -f /usr/local/bin/auto ]; then
			cp -a /usr/local/scripts/auto-rasp /usr/local/bin/auto
		fi
	       	/usr/bin/raspi-config --expand-rootfs
		cp -a /usr/local/scripts/rc.local-rasp /etc/rc.local
                mkdir /usr/src/${updateNOVO}
                reboot
        fi
executa=0

executa=1
updateNOVO="updateO4JULHO-001"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "muffatosuper" ]; then
		cp -a /usr/local/scripts/crontab-muffato /etc/crontab
	fi
	if [ $rede == "muffatomax" ]; then
		cp -a /usr/local/scripts/crontab-muffato /etc/crontab
	fi
	if [ $rede == "subwaysuper" ]; then
		loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
		if [ $loja == "mt_cuiaba_61847" ]; then
	        cp -a /usr/local/scripts/crontab-rasp-61847 /etc/crontab
		fi
		if [ $loja == "mt_primavera_do_leste_51271" ]; then
	        cp -a /usr/local/scripts/crontab-rasp-51271 /etc/crontab
		fi
		if [ $loja == "sp_sao_paulo_51914" ]; then
	        cp -a /usr/local/scripts/crontab-rasp-51914 /etc/crontab
		fi
		if [ $loja == "sp_caieiras_62858" ]; then
	        cp -a /usr/local/scripts/crontab-rasp-62858 /etc/crontab
		fi
	else
	        cp -a /usr/local/scripts/crontab-rasp /etc/crontab
	fi
                x=`cat /etc/crontab | grep checa_ip`
        	if [ $? == 1 ]; then
                        echo "*/30 * * * *	root /usr/local/bin/checa_ip" >> /etc/crontab
                fi
                y=`cat /etc/crontab | grep tocadas`
        	if [ $? == 1 ]; then
			echo "00 */1 * * *	root /usr/local/bin/tocadas.sh" >> /etc/crontab
			echo "01 */3 * * *	root /usr/local/bin/trata-log.sh" >> /etc/crontab
                fi
                z=`cat /etc/crontab | grep force`
        	if [ $? == 1 ]; then
                        echo "00 00 * * *	root /usr/local/bin/force_playlist.sh" >> /etc/crontab
                fi
                chmod 644 /etc/crontab
		if [ -f /usr/bin/telnet ]; then
			echo "Ja instalado - Telnet"
		else
			dpkg -i /usr/local/scripts/bind9.deb /usr/local/scripts/dnsutils.deb /usr/local/scripts/libbind.deb /usr/local/scripts/libdns.deb /usr/local/scripts/libisc95.deb /usr/local/scripts/libisccfg.deb /usr/local/scripts/liblwres.deb /usr/local/scripts/telnet_0.17-36_armhf.deb
			rm -f /etc/apt/apt.conf
			apt-get update
			apt-get -y install dnsutils
		fi
                chown root.root /etc/crontab
	fi
executa=0

executa=1
updateNOVO="update06Julho-001"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
                cp -a /usr/local/scripts/radio-rasp /usr/local/bin/radio.sh
                cp -a /usr/local/scripts/log-status-rasp /usr/local/bin/log-status.sh
		cp -a /usr/local/scripts/log.sh-debian /var/www/log.sh
		chmod 775 /var/www/log.sh 
		chmod 775 -R /var/log/radio
		rm -f /usr/local/bin/force_playlist.sh
		cp -a /usr/local/scripts/force_playlist-rasp /usr/local/bin/force_playlist.sh
		chmod 775 /usr/local/bin/force_playlist.sh
		chown radiob. -R /var/log/radio
		cp -a /usr/local/scripts/estrutura.sql /var/www/
		cp -a /usr/local/scripts/log_evento.sh /var/www/log_evento.sh
		chmod 775 -R /usr/local/radio/generos
		chown radiob. -R /usr/local/radio/generos
        fi
executa=0

executa=1
updateNOVO="updateROLDAO-FINAL001-11052017"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		(cd /var/www/; unzip -o /usr/local/scripts/_roldao.zip ; date > streaming_WEB_OK )
		chmod 775 -R /usr/local/bin/*
	fi
	mkdir /usr/src/${updateNOVO}
	fi
executa=0

executa=1
updateNOVO="updateROLDAO-16MAIO03"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		cp -a /usr/local/scripts/player.php-roldao /var/www/player.php
		cp -a /usr/local/scripts/volume_mais_input.php-roldao /var/www/volume_mais_input.php
		cp -a /usr/local/scripts/volume_mais.php-roldao /var/www/volume_mais.php
		cp -a /usr/local/scripts/volume_menos_input.php-roldao /var/www/volume_menos_input.php
		cp -a /usr/local/scripts/volume_menos.php-roldao /var/www/volume_menos.php
		chmod -R 755 /var/www/
		rm -f /etc/apt/apt.conf
		apt-get update
		apt-get -y install dnsutils
	fi
	mkdir /usr/src/${updateNOVO}
		reboot
	fi
executa=0

executa=1
updateNOVO="updateROLDAO-FINAL002-11052017"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		cp -a /usr/local/scripts/monitora_streaming.sh-roldao /var/www/monitora_streaming.sh
		rm -f /etc/crontab
		cp -a /usr/local/scripts/crontab-rasp-roldao /etc/crontab
		cat /usr/local/scripts/crontabs > /var/spool/cron/crontabs/root
		chown root. /etc/crontab
		chmod 644 /etc/crontab
		/etc/init.d/cron restart
		rm -f /usr/local/bin/log-status.sh
		cp -a /usr/local/scripts/log-status-rasp /usr/local/bin/log-status.sh
		chmod 775 -R /usr/local/bin/*
		bash -x checa_ip
		/usr/local/bin/log-status.sh
	fi
	fi
executa=0


executa=1
updateNOVO="updateROLDAO-corrigevolume"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
	if [ $loja == "zzz" ]; then
		cp -a /usr/local/scripts/config_entrada.php-zzz /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_009" ]; then
		cp -a /usr/local/scripts/config_entrada.php-web /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_018" ]; then
		cp -a /usr/local/scripts/config_entrada.php-web /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_031" ]; then
		cp -a /usr/local/scripts/config_entrada.php-web /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_030" ]; then
		cp -a /usr/local/scripts/config_entrada.php-web /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_026" ]; then
		cp -a /usr/local/scripts/config_entrada.php-web /var/www/config_entrada.php
	fi
		rm -rf /var/www/config_streaming.php
		mkdir /usr/src/${updateNOVO}
		reboot
	fi
executa=0

fi
#
#
#
############# VERSAO DEBIAN INICIO


if [ $VERSAO == "debian" ]; then
executa=1 
updateNOVO="22ABRIL2016" 
if [ ! -d /usr/share/${updateNOVO} -a $executa -eq 1 ]; then 
       	(cd /usr/src/; rm -rf update*) 
	(cd /tmp; rm -rf update*)
       	mkdir /usr/share/${updateNOVO} 
fi 
executa=0 

executa=1
update="update22ABRIL2016-001"
        if [ ! -d /usr/src/${update} -a $executa -eq 1 ]; then
	        cp -a /usr/local/scripts/crontab-debian /etc/crontab
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "muffatosuper" ]; then
		cp -a /usr/local/scripts/crontab-muffato /etc/crontab
	fi
	if [ $rede == "muffatomax" ]; then
		cp -a /usr/local/scripts/crontab-muffato /etc/crontab
	fi
                chmod 644 /etc/crontab
                chown root.root /etc/crontab
                x=`cat /etc/crontab | grep checa_ip`
        	if [ $? == 1 ]; then
                        echo "*/10 * * * *	root /usr/local/bin/checa_ip" >> /etc/crontab
                fi
                y=`cat /etc/crontab | grep tocadas`
        	if [ $? == 1 ]; then
			echo "00 */1 * * *	root /usr/local/bin/tocadas.sh" >> /etc/crontab
			echo "01 */3 * * *	root /usr/local/bin/trata-log.sh" >> /etc/crontab
                fi
                z=`cat /etc/crontab | grep force`
        	if [ $? == 1 ]; then
                        echo "00 00 * * *	root /usr/local/bin/force_playlist.sh" >> /etc/crontab
                fi
		rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
		if [ $rede == "Shopping" ]; then
			loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
			if [ $loja == "Centerlar" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Centerlar-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Sao_Leopoldo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Sao_Leopoldo-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Novo_Hamburgo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Novo_Hamburgo-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Praia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Praia-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Mag" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Mag-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Pompeia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Pompeia-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Tartine" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Tartine-debian /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Wallig" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Wallig-debian /usr/local/bin/radio-musical.sh
			fi
		else
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-debian /usr/local/bin/radio-musical.sh
		fi
                		cp /usr/local/scripts/lista.txt /tmp/lista.txt
                		cat /tmp/lista.txt | while read arquivo
       		do
                	find /usr/local/radio/generos/musical/ -iname "*${arquivo}*" -exec rm -f {} \;
                	echo "delete from arquivos where arquivo like '%${arquivo}%' and tipo='musical';" | mysql -u root radio
        	done
        fi
executa=0

executa=1
update="update22ABRIL2016-002"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
                > /var/log/radio/radio.log
		rm -f /usr/local/bin/trata-log.sh
                rm -f /usr/local/bin/trata-log.sh
                rm -f /usr/local/bin/trata.sh
		rm -f /usr/local/bin/descricao.sh
		#rm -f /var/www/playlist.php
		rm -f /usr/local/bin/logs_hora.sh
		rm -f /usr/local/bin/trata-log.sh
                cp -a /usr/local/scripts/aproveita_musicas-debian /usr/local/bin/aproveita_musicas.sh
                cp -a /usr/local/scripts/gera_playlist-debian /usr/local/bin/gera_playlist.sh
		cp -a /usr/local/scripts/limpa-log-debian /usr/local/bin/limpa-log.sh
                cp -a /usr/local/scripts/radio-update.body-debian /usr/local/etc/radio-update.body
		cp -a /usr/local/scripts/screenrc /root/.screenrc
		cp -a /usr/local/scripts/setup-debian /usr/local/bin/setup.sh
		cp -a /usr/local/scripts/tabela-outros /usr/local/bin/tabela
		cp -a /usr/local/scripts/volume_menos.php /var/www/volume_menos.php
		#cp -a /usr/local/scripts/playlist.php-debian /var/www/playlist.php
		cp -a /usr/local/scripts/tocadas.sh-debian /usr/local/bin/tocadas.sh
		cp -a /usr/local/scripts/trata-log.sh-debian /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/css2.css /var/www/locucao/css/css2.css
		cp -a /usr/local/scripts/app.js	/var/www/locucao/js/app.js
		cp -a /usr/local/scripts/oferta.php-routes /var/www/locucao/routes/oferta.php
		cp -a /usr/local/scripts/oferta.php-templates /var/www/locucao/templates/oferta.php
		cp -a /usr/local/scripts/trata-log.sh-debian /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/descricao.sh-debian /usr/local/bin/descricao.sh
		chmod 775 /usr/local/bin/tocadas.sh 
		chmod 775 /usr/local/bin/trata-log.sh
                mkdir /usr/src/${updateNOVO}
        fi
executa=0

executa=1
	updateNOVO="update06Julho-001"
       	if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
                cp -a /usr/local/scripts/radio-debian /usr/local/bin/radio.sh
		cp -a /usr/local/scripts/log-status-debian /usr/local/bin/log-status.sh
		cp -a /usr/local/scripts/log.sh-debian /var/www/log.sh
		chmod 775 /var/www/log.sh 
                cp -a /usr/local/scripts/checa_ip2 /usr/local/bin/checa_ip
		rm -f /usr/local/bin/force_playlist.sh
                cp -a /usr/local/scripts/force_playlist-debian /usr/local/bin/force_playlist.sh
		chmod 775 /usr/local/bin/force_playlist.sh
		chmod 775 -R /var/log/radio
		chown radiob. -R /var/log/radio
		cp -a /usr/local/scripts/estrutura.sql /var/www/
		cp -a /usr/local/scripts/log_evento.sh /var/www/log_evento.sh
		chmod 775 -R /usr/local/radio/generos
		chown radiob. -R /usr/local/radio/generos
		rm -f /etc/apt/apt.conf
		apt-get update
		apt-get -y install dnsutils
       	fi
executa=0

executa=1
updateNOVO="updateROLDAO-FINAL001-11052017"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		(cd /var/www/; unzip -o /usr/local/scripts/_roldao.zip ; date > streaming_WEB_OK )
		chmod 775 -R /usr/local/bin/*
	fi
	mkdir /usr/src/${updateNOVO}
	fi
executa=0

executa=1
updateNOVO="updateROLDAO-16MAIO03"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		cp -a /usr/local/scripts/player.php-roldao /var/www/player.php
		cp -a /usr/local/scripts/volume_mais_input.php-roldao /var/www/volume_mais_input.php
		cp -a /usr/local/scripts/volume_mais.php-roldao /var/www/volume_mais.php
		cp -a /usr/local/scripts/volume_menos_input.php-roldao /var/www/volume_menos_input.php
		cp -a /usr/local/scripts/volume_menos.php-roldao /var/www/volume_menos.php
		chmod 775 -R /var/www/
	fi
	mkdir /usr/src/${updateNOVO}
		reboot
	fi
executa=0

executa=1
updateNOVO="updateROLDAO-FINAL002-11052017"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	rede=`cat /var/www/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "roldao" ]; then
		cp -a /usr/local/scripts/monitora_streaming.sh-roldao /var/www/monitora_streaming.sh
		rm -f /etc/crontab
		cp -a /usr/local/scripts/crontab-rasp-roldao /etc/crontab
		cat /usr/local/scripts/crontabs > /var/spool/cron/crontabs/root
		chown root. /etc/crontab
		chmod 644 /etc/crontab
		/etc/init.d/cron restart
		rm -f /usr/local/bin/log-status.sh
		cp -a /usr/local/scripts/log-status-debian /usr/local/bin/log-status.sh
		chmod 775 -R /usr/local/bin/*
		bash -x checa_ip
		/usr/local/bin/log-status.sh
	fi
	fi
executa=0

executa=1
updateNOVO="updateROLDAO-corrigevolume"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
	loja=`cat /var/www/config.inc.php | grep loja | cut -d "'" -f2`
	if [ $loja == "Lj_024" ]; then
		cp -a /usr/local/scripts/config_entrada.php-sat /var/www/config_entrada.php
	fi
	if [ $loja == "Lj_001" ]; then
		cp -a /usr/local/scripts/config_entrada.php-sat /var/www/config_entrada.php
	fi
		rm -rf /var/www/config_streaming.php
		mkdir /usr/src/${updateNOVO}
		reboot
	fi
executa=0

fi


############# VERSAO ANTIGA INICIO

if [ $VERSAO == "Antiga" ]; then
	echo antiga > /etc/VERSAO
fi

x=`cat /etc/VERSAO`
if [ $? == 1 ]; then
VERSAO="antiga"
	echo antiga > /etc/VERSAO
fi

if [ $VERSAO == "antiga" ]; then

executa=1 
updateNOVO="22ABRIL2016" 
if [ ! -d /usr/share/${updateNOVO} -a $executa -eq 1 ]; then 
       	(cd /usr/src/; rm -rf update*) 
	(cd /tmp; rm -rf update*)
       	mkdir /usr/share/${updateNOVO} 
fi
executa=0 
 
executa=1
update="update22ABRIL2016-001"
                cp -a /usr/local/scripts/crontab-antiga /etc/crontab
	rede=`cat /var/www/html/config.inc.php | grep rede | cut -d "'" -f2`
	if [ $rede == "Muffato" ]; then
		cp -a /usr/local/scripts/crontab-muffato /etc/crontab
	fi
                chmod 644 /etc/crontab
                chown root.root /etc/crontab
	if [ ! -d /usr/src/${update} -a $executa -eq 1 ]; then
                y=`cat /etc/crontab | grep checa_ip`
        	if [ $? == 1 ]; then
                        echo "*/30 * * * *	root /usr/local/bin/checa_ip" >> /etc/crontab
                fi
        	z=`cat /etc/crontab | grep tabela`
        	if [ $? == 1 ]; then
                	echo "00 03 * * 7,2 root /usr/local/bin/tabela" >> /etc/crontab
        	fi
		w=`cat /etc/crontab | grep tocadas`
                if [ $? == 1 ]; then
                        echo "00 */1 * * *      root /usr/local/bin/tocadas.sh" >> /etc/crontab
                        echo "01 */3 * * *      root /usr/local/bin/trata-log.sh" >> /etc/crontab
                fi
		rede=`cat /var/www/html/config.inc.php | grep rede | cut -d "'" -f2`
		if [ $rede == "Shopping" ]; then
			loja=`cat /var/www/html/config.inc.php | grep loja | cut -d "'" -f2`
			if [ $loja == "Centerlar" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Centerlar /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Novo_Hamburgo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Novo_Hamburgo /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Sao_Leopoldo" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Sao_Leopoldo /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Praia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Praia /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Mag" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Mag /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Wallig" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Wallig /usr/local/bin/radio-musical.sh
			fi
			if [ $loja == "Bourbon_Pompeia" ]; then
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-Bourbon_Pompeia /usr/local/bin/radio-musical.sh
			fi
		else
				rm -f /usr/local/bin/radio-musical.sh
				cp -a /usr/local/scripts/radio-musical-antiga /usr/local/bin/radio-musical.sh
		fi
        	cp /usr/local/scripts/lista.txt /tmp/lista.txt
        	cat /tmp/lista.txt | while read arquivo
        	do
                	find /usr/local/radio/generos/musical/ -iname "*${arquivo}*" -exec rm -f {} \;
                	echo "delete from arquivos where arquivo like '%${arquivo}%' and tipo='musical';" | mysql -u root radio
        	done
	fi
executa=0

executa=1
updateNOVO="update-02MAIO2016-001"
        if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
		rm -rf /usr/src/update-22ABRIL2016-002
		chmod 2777 -R /var/log/radio
		chown radiob. -R /var/log/radio
		rm -f /usr/local/bin/log.sh
		rm -f /usr/local/bin/logmon.sh
		rm -f /usr/local/bin/recriaPlaylist.sh
		rm -f /usr/local/bin/trata-log.sh
		rm -f /usr/local/bin/trata.sh
		rm -r /usr/local/bin/telaEspera
		rm -f /var/www/html/playlist.php
		rm -f /usr/local/bin/trata-log.sh
		mv /usr/bin/curl /usr/bin/curl.mm
                > /var/log/radio/radio.log
		cp -a /usr/local/scripts/log.sh-antiga /usr/local/bin/log.sh
		cp -a /usr/local/scripts/trata-log.sh-antiga /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/tocadas.sh-antiga   /usr/local/bin/tocadas.sh
		cp -a /usr/local/scripts/descricao.sh-antiga /usr/local/bin/descricao.sh
		cp -a /usr/local/scripts/log.sh-antiga /usr/local/bin/log.sh
		cp -a /usr/local/scripts/trata-log.sh-antiga /usr/local/bin/trata-log.sh
		cp -a /usr/local/scripts/tocadas.sh-antiga   /usr/local/bin/tocadas.sh
		cp -a /usr/local/scripts/audiencia-antiga /usr/local/bin/audiencia.sh
		cp -a /usr/local/scripts/audiencia-gera-antiga /usr/local/bin/audiencia-gera.sh
        	cp -a /usr/local/scripts/aproveita_musicas-antiga /usr/local/bin/aproveita_musicas.sh
        	cp -a /usr/local/scripts/hora-antiga /usr/local/bin/hora
		cp -a /usr/local/scripts/radio-update.body-antiga /usr/local/etc/radio-update.body
        	cp -a /usr/local/scripts/radio-musical-antiga /usr/local/bin/radio-musical.sh
        	cp -a /usr/local/scripts/sql-antiga /usr/local/bin/sql
        	cp -a /usr/local/scripts/som-antiga /usr/local/bin/som
        	cp -a /usr/local/scripts/setup-antiga /usr/local/bin/setup.sh
		cp -a /usr/local/scripts/playlist.php-antiga /var/www/html/playlist.php
		echo "oi" > /usr/bin/curl
		chmod 755 /usr/bin/curl
		chmod 775 /usr/local/bin/tocadas.sh 
		chmod 775 /usr/local/bin/trata-log.sh
		chmod 775 /usr/local/bin/log.sh
		chmod 775 /usr/local/bin/tocadas.sh 
		chmod 775 /usr/local/bin/trata-log.sh
		chmod 775 /usr/local/bin/log.sh
        	chmod 775 /usr/local/bin/radio-musical.sh
        	chmod 775 /usr/local/bin/tabela
        	chmod 775 /usr/local/bin/hora
       		chmod 775 /usr/local/bin/sql
        	chmod 775 /usr/local/bin/som
		chown radiob. -R /var/www/html/
                mkdir /usr/src/${updateNOVO}
        fi
executa=0

executa=1
	updateNOVO="update06Julho-001"
       	if [ ! -d /usr/src/${updateNOVO} -a $executa -eq 1 ]; then
		rm -f /usr/local/bin/tabela
		cp -a /usr/local/scripts/tabela-antiga /usr/local/bin/tabela
		cp -a /usr/local/scripts/checa_ip-antiga2 /usr/local/bin/checa_ip
		cp -a /usr/local/scripts/log-status-antiga /usr/local/bin/log-status.sh
		chmod 2775 -R /var/log/radio
		chown radiob. -R /var/log/radio
		cp -a /usr/local/scripts/estrutura.sql /var/www/html/
		cp -a /usr/local/scripts/player.php-antiga /var/www/html/player.php
		chown radiob.root /usr/local/bin/*
		chmod 775 /usr/local/bin/*
		chmod 775 -R /srv/www/htdocs
		chown radiob.www -R /srv/www/htdocs
		chmod 775 -R /usr/local/radio/generos
		chown radiob. -R /usr/local/radio/generos
       	fi
executa=0
fi
