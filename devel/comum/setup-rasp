#!/bin/bash


# Executa ate cancelar
while [ 'cat /dev/null' ]; do

	# Título de fundo
	titulo="SETUP - Configuracao de rede para o Raspbian - Radio"

	# Menu inicial
	dialog --backtitle "$titulo"\
	       --title " MENU PRINCIPAL "\
	       --menu "" 11 47 5 "1" "Verifica pre-requisitos"\
	                         "2" "Configura a rede"\
				 "3" "Agenda o horario de atualizacao"\
				 "4" "Mostra parametros configurados"\
				 "5" "Sair [Ctrl C]"\
	       2> s_menu

	# Cancelar, remove arquivo temporário
	if [ $? = 1 ]; then
		rm -f s_menu
		clear
		exit 0
	fi

	# Captura e processa a opção escolhida no menu
	opcao=`cat s_menu`

	case $opcao in

		# Verifica pre-requisitos
		"1" )
			# Pede a confirmacao para o inicio da verificacao
			dialog --backtitle "$titulo"\
			       --title "Verifica pre-requisitos"\
			       --yesno "Confirma o inicio da verificacao dos pre-requisitos?" 5 56

			confirma=$?
			if [ "$confirma" == "0" ]; then
			    dialog --backtitle "$titulo"\
			           --title "Verifica pre-requisitos"\
			           --infobox "Aguarde enquanto o sistema esta sendo verificado..." 3 55

			    # Verifica se o pacote EXPECT esta instalado

			    # Verifica a existencia do usuario 500 como radiob
			    if [ $(cat /etc/passwd | grep radiob | grep 1001 | wc -l) -gt 0 ]; then
				usuario="OK"
			    else
				usuario="*** FALHOU ***"
			    fi

			    # Verifica a existencia do repositorio de scripts
			    if [ -d /usr/local/scripts ]; then
				scripts="OK"
			    else
				scripts="*** FALHOU ***"
			    fi

			    # Verifica a existencia do arquivo /etc/radio.update
			    if [ -e /etc/radio.update ]; then
				senha="OK"
			    else
				senha="*** FALHOU ***"
			    fi

			    # Mostra o resultado da verificacao de pre-requisitos de sistema
			    dialog --backtitle "$titulo"\
			           --title "Verifica pre-requisitos"\
			           --msgbox "\
Resultado da verificacao de pre-requisitos de sistema:\n\n\
Usuario radiob......................: $usuario\n\
Existencia do repositorio de scripts: $scripts\n\
Existencia do arquivo radio.update..: $senha" 12 58
			fi ;;

		# Configura a rede
		"2" )
			# Captura o nome da Rede
			dialog --backtitle "$titulo"\
			       --title " QUAL A REDE? "\
			       --inputbox "" 7 36\
			       2> s_menu

			if [ $? = 1 ]; then
				continue
			fi

			rede=`cat s_menu`

			# Captura o nome da Loja
			dialog --backtitle "$titulo"\
			       --title " QUAL A LOJA? "\
			       --inputbox "" 7 36\
			       2> s_menu

			if [ $? = 1 ]; then
				continue
			fi

			loja=`cat s_menu`

			ip3=1
			retorna=0
			while [ "$ip3" == "1" ]; do
			    # Captura o endereco IP do servidor Datacenter
			    dialog --backtitle "$titulo"\
			           --title " QUAL O IP DO SERVIDOR DATACENTER? "\
				   --inputbox "" 7 40\
				   2> s_menu

			    if [ $? = 1 ]; then
				retorna=1
				break
			    fi

			    ip_datacenter=`cat s_menu`

			    # Valida o IP
			    ip2=`echo "$ip_datacenter" | awk 'BEGIN { RS = "[. ]" }\
			         { if ($1 >= 0 && $1 <= 255) { printf "%03s.", $1 } else\
			         { printf "X" } }' | sed 's/\.$//'`

			    ip3=`[ \`expr index "$ip2" X\` = 0 -a \`echo "$ip2" | grep -c\
			         [A-Za-z]\` = 0 -a ${#ip2} = 15 ] && echo -n\
			         0 || echo -n 1`

			    # Mensagem de IP invalido
			    if [ "$ip3" == "1" ]; then
				dialog --backtitle "$titulo"\
				       --title "Configura a rede"\
				       --msgbox "Endereco IP invalido. Reinforme!" 5 36
		    	    fi
			done

			if [ $retorna == 1 ]; then
				continue
			fi

			ip3=1
			retorna=0
			while [ "$ip3" == "1" ]; do
			    # Captura o endereco IP do servidor de hora
			    dialog --backtitle "$titulo"\
			           --title " QUAL O IP DO SERVIDOR DE HORA? "\
				   --inputbox "" 7 40\
				   2> s_menu

			    if [ $? = 1 ]; then
				retorna=1
				break
			    fi

			    ip_hora=`cat s_menu`

			    # Valida o IP
			    ip2=`echo "$ip_hora" | awk 'BEGIN { RS = "[. ]" }\
			         { if ($1 >= 0 && $1 <= 255) { printf "%03s.", $1 } else\
			         { printf "X" } }' | sed 's/\.$//'`

			    ip3=`[ \`expr index "$ip2" X\` = 0 -a \`echo "$ip2" | grep -c\
			         [A-Za-z]\` = 0 -a ${#ip2} = 15 ] && echo -n\
			         0 || echo -n 1`

			    # Mensagem de IP invalido
			    if [ "$ip3" == "1" ]; then
				dialog --backtitle "$titulo"\
				       --title "Configura a rede"\
				       --msgbox "Endereco IP invalido. Reinforme!" 5 36
		    	    fi
			done

			if [ $retorna == 1 ]; then
				continue
			fi

			ip3=1
			retorna=0

                        # Confirma tipo de rede para IP fixo ou DHCP.
			# Caso seja fixo captura os valores de rede, mask, e gateway

                        dialog --backtitle "$titulo"\
                               --title "Configura o tipo de rede"\
                               --yesno "Deseja utilizar DHCP?" 5 56

			dhcp=$?

			if [ $dhcp -eq 0 ]
			then
				dinamico_statico=dhcp
			else	
				dinamico_statico=static
				while [ "$ip3" == "1" ]; do

				    # Captura o endereco IP da CPU da loja
				    dialog --backtitle "$titulo"\
				           --title " QUAL O IP DA CPU DA LOJA? "\
					   --inputbox "" 7 40\
					   2> s_menu

				    if [ $? = 1 ]; then
					retorna=1
					break
				    fi

				    ip_loja=`cat s_menu`

				    # Valida o IP
				    ip2=`echo "$ip_loja" | awk 'BEGIN { RS = "[. ]" }\
				         { if ($1 >= 0 && $1 <= 255) { printf "%03s.", $1 } else\
				         { printf "X" } }' | sed 's/\.$//'`
	
				    ip3=`[ \`expr index "$ip2" X\` = 0 -a \`echo "$ip2" | grep -c\
				         [A-Za-z]\` = 0 -a ${#ip2} = 15 ] && echo -n\
				         0 || echo -n 1`

				    # Mensagem de IP invalido
				    if [ "$ip3" == "1" ]; then
					dialog --backtitle "$titulo"\
					       --title "Configura a rede"\
					       --msgbox "Endereco IP invalido. Reinforme!" 5 36
			    	    fi
				done

				if [ $retorna == 1 ]; then
					continue
				fi

				mask3=1
				retorna=0
					while [ "$mask3" == "1" ]; do
				    # Captura a mascara do endereco IP da CPU da loja
				    dialog --backtitle "$titulo"\
				           --title " QUAL A MASCARA DO IP DA CPU DA LOJA? "\
					   --inputbox "" 7 44\
					   2> s_menu
	
				    if [ $? = 1 ]; then
					retorna=1
					break
				    fi

				    ip_mask=`cat s_menu`
	
				    # Valida a mascara de rede
				    mask2=`echo "$ip_mask" | awk 'BEGIN { RS = "[. ]" }\
			        	   { if ($1 >= 0 && $1 <= 255) { printf "%03s.", $1 } else\
					   { printf "X" } }' | sed 's/\.$//'`

		        	    mask3=`[ \`expr index "$mask2" X\` = 0 -a \`echo "$mask2" |\
				           grep -c [A-Za-z]\` = 0 -a ${#mask2} = 15 ] && echo -n\
					   0 || echo -n 1`

				    # Mensagem de mascara invalida
				    if [ "$mask3" == "1" ]; then
					dialog --backtitle "$titulo"\
					       --title "Configura a rede"\
					       --msgbox "Mascara de rede invalida. Reinforme!" 5 40
			    	    fi
				done

				if [ $retorna == 1 ]; then
					continue
				fi	

				ip3=1
				retorna=0
				while [ "$ip3" == "1" ]; do
				    # Captura o endereco IP de gateway
				    dialog --backtitle "$titulo"\
				           --title " QUAL O IP DO GATEWAY? "\
					   --inputbox "" 7 40\
					   2> s_menu

				    if [ $? = 1 ]; then
					retorna=1
					break
				    fi
	
				    ip_gateway=`cat s_menu`

				    # Valida o IP
				    ip2=`echo "$ip_gateway" | awk 'BEGIN { RS = "[. ]" }\
			        	 { if ($1 >= 0 && $1 <= 255) { printf "%03s.", $1 } else\
				         { printf "X" } }' | sed 's/\.$//'`

				    ip3=`[ \`expr index "$ip2" X\` = 0 -a \`echo "$ip2" | grep -c\
				         [A-Za-z]\` = 0 -a ${#ip2} = 15 ] && echo -n\
				         0 || echo -n 1`

				    # Mensagem de IP invalido
				    if [ "$ip3" == "1" ]; then
					dialog --backtitle "$titulo"\
					       --title "Configura a rede"\
					       --msgbox "Endereco IP invalido. Reinforme!" 5 36
			    	    fi
				done

				if [ $retorna == 1 ]; then
					continue
				fi
		fi
			ip3=1
			retorna=0
			

			# Captura o hostname
			dialog --backtitle "$titulo"\
			       --title " QUAL O HOSTNAME? "\
			       --inputbox "" 7 36\
			       2> s_menu

			if [ $? = 1 ]; then
				continue
			fi

			hname=`cat s_menu`

			# Mostra todas as configuracoes informadas e pede uma confirmacao
			dialog --backtitle "$titulo"\
			       --title "Configura a rede"\
			       --yesno "\
Resumo das configuracoes informadas:\n\n\
Rede........................: '$rede'\n\
Loja........................: '$loja'\n\
IP do servidor datacenter...: '$ip_datacenter'\n\
IP do servidor de hora......: '$ip_hora'\n\
IP da CPU da loja...........: '$ip_loja'\n\
Mascara de IP da CPU da loja: '$ip_mask'\n\
IP do gateway...............: '$ip_gateway'\n\
Hostname....................: '$hname'\n\n\
Tem CERTEZA de que as informacoes estao TODAS corretas?" 18 60

			confirma=$?
			if [ "$confirma" == "0" ]; then
			    dialog --backtitle "$titulo"\
			           --title "Configura a rede"\
			           --infobox "Aguarde enquanto os arquivos estao sendo criados..." 3 55

			    # Constroi o arquivo /etc/network/interfaces
		     	    START="/usr/local/etc/interfaces"
if [ $dhcp -eq 0 ]; then

cat << __EOF__ > $START
auto lo

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
__EOF__

else

cat << __EOF__ > $START
auto lo eth0

iface lo inet loopback
iface eth0 inet static
	address $ip_loja
	netmask $ip_mask
	gateway $ip_gateway	

#allow-hotplug wlan0
#iface wlan0 inet manual
#wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
#iface default inet dhcp
__EOF__

fi
			    # Constroi o arquivo /usr/local/etc/network
			    echo "$hname" > /usr/local/etc/HOSTNAME
			    CURRENT_HOSTNAME=`cat /usr/local/etc/HOSTNAME | tr -d " \t\n\r"`
			    CURRENT1_HOSTNAME=`cat /etc/hosts | grep 127.0.1.1 | tr -d " \t\n\r"`
			    echo $CURRENT_HOSTNAME > /etc/hostname
			    sed -i "s/^127.0.1.1.*/127.0.1.1\t$CURRENT_HOSTNAME/g" /etc/hosts

			    # Constroi o arquivo radio-update.sh
			    echo -e "#!/bin/bash\n" > /usr/local/etc/radio-update.sh
			    echo "# radio-update.sh: Atualizacao do Servidor de Radio da Loja - RASPBIAN" >> /usr/local/etc/radio-update.sh
			    echo -e "# 2015-02-24\n" >> /usr/local/etc/radio-update.sh
			    echo -e "# Gildecio E Barboza gildecio@gmail.com\n" >> /usr/local/etc/radio-update.sh
			    echo -e "rede=\042$rede\042" >> /usr/local/etc/radio-update.sh
			    echo -e "loja=\042$loja\042" >> /usr/local/etc/radio-update.sh
			    echo -en "ip=\042" >> /usr/local/etc/radio-update.sh
			    echo -e "$ip_datacenter\042" >> /usr/local/etc/radio-update.sh
			    echo -en "hora=\042" >> /usr/local/etc/radio-update.sh
			    echo -e "$ip_hora\042" >> /usr/local/etc/radio-update.sh
			    echo -e "data=\`date +%Y%m%d\`" >> /usr/local/etc/radio-update.sh
			    echo -e "reinicia=\042nao\042\n" >> /usr/local/etc/radio-update.sh
			    cat /usr/local/etc/radio-update.body >> /usr/local/etc/radio-update.sh

			    chmod 755 /usr/local/etc/radio-update.sh

			    # Copia os arquivos criados para os locais definitivos
			    cp -pf /usr/local/etc/interfaces	/etc/network/interfaces
			    cp -pf /usr/local/etc/radio-update.sh /usr/local/bin
			    chmod +x /usr/local/bin/*

			    # Modifica o arquivo config.inc.php com o nome da Rede e da Loja
			    printf "<?php\n\$rede = '$rede';\n\$loja = '$loja';\n?>" > \
				    /var/www/config.inc.php

 
		# Reinicia interface de rede
		# Pode ocasionar queda na conexao caso DHCP pegue outro endereco de rede via acesso remoto.

	   		dialog --backtitle "$titulo"\
        			--title "Restart de rede"\
		        	--yesno "Deseja reiniciar interface de rede?" 5 56

		        interface=$?

			if [ $interface -eq 0 ]
			then
				ifconfig eth0 $ip_loja netmask $ip_mask
			fi


			fi ;;

		# Agenda o horario de atualizacao
		"3" )
			# Captura a hora
			retorna=0
			while [ 'cat /dev/null' ]; do
			    # Captura a hora para a atualizacao
			    dialog --backtitle "$titulo"\
			           --title " QUAL A HORA? "\
				   --inputbox "" 7 26\
				   2> s_menu

			    if [ $? = 1 ]; then
				retorna=1
				break
			    fi

			    hora=`cat s_menu`

			    # Mensagem de hora invalida
			    if [ "$hora" -lt 0 ]; then
				dialog --backtitle "$titulo"\
				       --title "Agenda o horario de atualizacao"\
			    	       --msgbox "Hora invalida. Precisa ser entre 0 e 23. Reinforme!" 5 55
			    else
				if [ "$hora" -gt 23 ]; then
				    dialog --backtitle "$titulo"\
				           --title "Agenda o horario de atualizacao"\
				           --msgbox "Hora invalida. Precisa ser entre 0 e 23. Reinforme!" 5 55
				else
				    break
				fi
		    	    fi
			done

			if [ $retorna == 1 ]; then
				continue
			fi

			# Captura o minuto
			retorna=0
			while [ 'cat /dev/null' ]; do
			    # Captura o minuto para a atualizacao
			    dialog --backtitle "$titulo"\
			           --title " QUAL O MINUTO? "\
				   --inputbox "" 7 26\
				   2> s_menu

			    if [ $? = 1 ]; then
				retorna=1
				break
			    fi

			    minuto=`cat s_menu`

			    # Mensagem de minuto invalido
			    if [ "$minuto" -lt 0 ]; then
				dialog --backtitle "$titulo"\
				       --title "Agenda o horario de atualizacao"\
			    	       --msgbox "Minuto invalido. Precisa ser entre 0 e 59. Reinforme!" 5 57
			    else
				if [ "$minuto" -gt 59 ]; then
				    dialog --backtitle "$titulo"\
				           --title "Agenda o horario de atualizacao"\
				           --msgbox "Minuto invalido. Precisa ser entre 0 e 59. Reinforme!" 5 57
				else
				    break
				fi
		    	    fi
			done

			if [ $retorna == 1 ]; then
				continue
			fi





			# Captura o dia de atualizacao com base na tabela do crontab. caso seja *
			retorna=0
			while [ 'cat /dev/null' ]; do
			
			dialog --backtitle "$titulo"\
			       --title "configuracao dia da semana"\
			       --msgbox "\
Para configurar o Dia de atualizacao utilize\n\n\
Segunda-feira.............: 1 \n\
Terca-feira...............: 2 \n\
Quarta-feira..............: 3 \n\
Quinta-feira..............: 4 \n\
Sexta-feira...............: 5 \n\
Sabado....................: 6 \n\
Domingo...................: 7 \n\
Todos.....................: * \n\n\

Para sequencia de dias utilize virgula sem espaco " 17 60 



			    # Captura o dia para a atualizacao
			    dialog --backtitle "$titulo"\
			           --title " QUAL O DIA?"\
				   --inputbox "" 7 26\
				   2> s_menu

			    if [ $? = 1 ]; then
				retorna=1
				break
			    fi

			    dia=`cat s_menu`

			    # Mensagem de dia invalido
			    if [ "$dia" -lt 1 ]; then
				dialog --backtitle "$titulo"\
				       --title "Agenda o dia de atualizacao"\
			    	       --msgbox "dia invalido. Precisa ser entre 1 e 7 ou *. Reinforme!" 5 57
			    else
				if [ "$dia" -gt 7 ]; then
				    dialog --backtitle "$titulo"\
				           --title "Agenda o horario de atualizacao"\
				           --msgbox "dia invalido. Precisa ser entre 1 e 7 ou * . Reinforme!" 5 57
				else
				    break
				fi
		    	    fi
			done

			if [ $retorna == 1 ]; then
				continue
			fi




			# Mostra todas as configuracoes informadas e pede uma confirmacao
			dialog --backtitle "$titulo"\
			       --title "Agenda o horario de atualizacao"\
			       --yesno "\
Resumo das configuracoes informadas:\n\n\
Horario de atualizacao: '$hora:$minuto no dia da semana $dia'\n\n\
Tem CERTEZA de que as informacoes estao TODAS corretas?" 9 59

			confirma=$?
			if [ "$confirma" == "0" ]; then
			    dialog --backtitle "$titulo"\
			           --title "Configura a rede"\
			           --infobox "Aguarde enquanto os arquivos estao sendo criados..." 3 55

			    # Constroi o arquivo crontab
			    echo "SHELL=/bin/bash" > /usr/local/etc/crontab
			    echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin" >> /usr/local/etc/crontab
			    echo "MAILTO=root" >> /usr/local/etc/crontab
			    echo -e "HOME=/\n" >> /usr/local/etc/crontab
				
			    dataAtualizacao=`date`

			    echo "### ultima modificacao: " >> /usr/local/etc/crontab
			    echo "### Via Setup - 21 Jul 2016" >> /usr/local/etc/crontab
			    echo "### Por: Gildecio E Barboza <gildecio@gmail.com> " >> /usr/local/etc/crontab
			    echo "" >> /usr/local/etc/crontab
			    echo "" >> /usr/local/etc/crontab
			    echo "40 * * * *	root /usr/local/bin/log-status.sh" >> /usr/local/etc/crontab
			    echo "*/10 * * * *	root /usr/local/bin/checa_ip" >> /usr/local/etc/crontab
			    echo "$minuto $hora * * $dia root /usr/local/bin/radio-update.sh" >> /usr/local/etc/crontab
			    echo "00 02 * * *	root /usr/local/bin/radio-musical.sh" >> /usr/local/etc/crontab
			    echo "00 07 * * *	root /sbin/reboot" >> /usr/local/etc/crontab
                            echo "00 16 * * *	root /usr/local/bin/limpa-log.sh" >> /usr/local/etc/crontab

			    # Copia o arquivo criado para o local definitivo
			    cp -a /usr/local/etc/crontab /etc
			    chown root. /etc/crontab
			fi ;;

		# Mostra parametros configurados
		"4" )
			dialog --backtitle "$titulo"\
			       --title "Mostra parametros configurados"\
			       --infobox "Aguarde obtencao de parametros de configuracao..." 3 53

			rede=`cat /usr/local/bin/radio-update.sh | grep rede= | cut -d'"' -f2`
			loja=`cat /usr/local/bin/radio-update.sh | grep loja= | cut -d'"' -f2`
			ip_datacenter=`cat /usr/local/bin/radio-update.sh | grep ip= | cut -d'"' -f2`
			ip_hora=`cat /usr/local/bin/radio-update.sh | grep hora= | cut -d'"' -f2`
			ip_loja=`cat /etc/network/interfaces | grep address | cut -d' ' -f2`
			ip_mask=`cat /etc/network/interfaces | grep netmask | cut -d' ' -f2`
			ip_gateway=`cat /etc/network/interfaces |grep gateway | cut -d' ' -f2`
			hname=`cat /etc/hostname`
			hora=`cat /etc/crontab | grep /usr/local/bin/radio-update.sh | cut -d' ' -f2`
			minuto=`cat /etc/crontab | grep /usr/local/bin/radio-update.sh | cut -d' ' -f1`
			dia=`cat /etc/crontab | grep /usr/local/bin/radio-update.sh | cut -d' ' -f5`



			# Mostra os parametros configurados
			dialog --backtitle "$titulo"\
			       --title "Mostra parametros configurados"\
			       --msgbox "\
Rede........................: '$rede'\n\
Loja........................: '$loja'\n\
IP do servidor datacenter...: '$ip_datacenter'\n\
IP do servidor de hora......: '$ip_hora'\n\
IP da CPU da loja...........: '$ip_loja'\n\
Mascara de IP da CPU da loja: '$ip_mask'\n\
IP do gateway...............: '$ip_gateway'\n\
Hostname....................: '$hname'\n\
Horario de atualizacao......: '$hora:$minuto'\n\
Dia de atualizacao..........: '$dia'" 15 60 ;;

		# Sair
		"5" )
			# Remove arquivo temporário
			rm -f s_menu
			clear
			exit 0 ;;
	esac
done 2> /dev/null
