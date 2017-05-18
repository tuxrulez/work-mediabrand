#!/bin/bash
server="131.255.239.38" ## Server-Local - megamidia
dir_pacotes="/home/pacotes"
anuncio="/tmp/anuncio"
senha="dtcomm3g4m1d14"

while [ `echo "SELECT status_encapsulador FROM tbl_encapsulador LIMIT 1" | mysql -h$server -udtcom -p$senha CTRL_DTCOM | grep -v status_encapsulador` -eq 1 ]
do
        #sincroniza diretorio de pacotes para poder efetuar a transmissao
        #/usr/bin/rsync -av --timeout=180 --delete-after --password-file=/etc/tv.update rsync://radiob@$server/pacotes/ $dir_pacotes >> /var/log/sync_pacotes.log

        valor=`echo "SELECT COUNT(*) FROM tbl_clientes WHERE status=1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_cliente | grep -v COUNT`

        if [ "$valor" -gt 0 ]
        then
                valor=`echo "SELECT cod_cliente,rede_cliente FROM tbl_clientes WHERE status=1 AND status_envio=1 ORDER BY cod_cliente LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_cliente`

                if [ "$valor" != "" ]
                then

                        cod_cliente=`echo $valor | cut -d" " -f1`
                        rede_cliente=`echo $valor | cut -d" " -f2`

                        # Inicio carrossel pacotes do cliente

                        limite_transmissoes=`echo "SELECT limite_transmissoes FROM tbl_encapsulador" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v limite_transmissoes`

                        valor=`echo "SELECT cod_pacote, qtde_transmissoes_efetuadas, tarja_pacote, seq_pacote, dt_hora_criacao, nome_pacote FROM tbl_pacotes WHERE cod_cliente='$cod_cliente' AND qtde_transmissoes_efetuadas < '$limite_transmissoes' AND status=1 ORDER BY qtde_transmissoes_efetuadas ASC, dt_hora_criacao DESC LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_pacote`

                        cod_pacote=`echo $valor | cut -d" " -f1`
                        qtde_t=`echo $valor | cut -d" " -f2`
                        tarja_pacote=`echo $valor | cut -d" " -f3`
                        seq_pacote=`echo $valor | cut -d" " -f4`
                        dt_criacao=`echo $valor | cut -d" " -f5`
                        hora_criacao=`echo $valor | cut -d" " -f6`
                        nome_pacote=`echo $valor | cut -d" " -f7`
                        dt_hora_criacao="$dt_criacao $hora_criacao"

                        if [ "$cod_pacote" != "" -a "$tarja_pacote" != "" -a "$seq_pacote" != "" -a "$dt_hora_criacao" != "" -a "$nome_pacote" != "" ]
                        then
                                #md5 do pacote
                                md5sum=`/usr/bin/md5sum $dir_pacotes/$rede_cliente/${rede_cliente}_${tarja_pacote}_update.tar.gz | cut -d' ' -f 1`

                                #separa as lojas para o anuncio do pacote
                                lojas="";

                                for i in `cat $dir_pacotes/$rede_cliente/lojas_${rede_cliente}_${tarja_pacote}.txt`;
                                do
                                        lojas=`echo $lojas $i`;
                                done;

                                #monta anuncio temporario
                                echo "rede:$rede_cliente" > $anuncio
                                echo "lojas:$lojas" >> $anuncio
                                echo "seq_pacote:$seq_pacote" >> $anuncio
                                echo "dt_criacao:$dt_hora_criacao" >> $anuncio
                                echo "porta:14565" >> $anuncio
                                echo "nome_pacote:$nome_pacote" >> $anuncio
                                echo "md5:$md5sum" >> $anuncio
                                echo "id_pacote:$cod_pacote" >> $anuncio

                                #parametros para a transmissao
                                valor=`echo "SELECT endereco_mcast, bitrate, port_base_anuncio, port_base_pacote, interface, fec FROM tbl_encapsulador LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v endereco_mcast`

                                #endereco de multicast
                                endereco_mcast=`echo $valor | cut -d" " -f1`

                                #taxa de transmissao permitida
                                bitrate=`echo $valor | cut -d" " -f2`

                                #porta base que sera transmitido o anuncio
                                port_base_anuncio=`echo $valor | cut -d" " -f3`

                                #porta que sera transmitido o pacote
                                port_base_pacote=`echo $valor | cut -d" " -f4`

                                #interface a ser utilizada
                                interface=`echo $valor | cut -d" " -f5`

                                #fec a ser utilizado
                                fec=`echo $valor | cut -d" " -f6`

                                if [ "$endereco_mcast" != "" -a  "$bitrate" != "" -a "$port_base_anuncio" != "" -a  "$port_base_pacote" != "" -a "$interface" != "" -a  "$fec" != "" ]
                                then
                                        log_anuncio=`/usr/bin/udp-sender --async --ttl 64 --mcast-data-address $endereco_mcast --mcast-rdv-addr $endereco_mcast  --autostart 1 --fec $fec --max-bitrate $bitrate --interface $interface --portbase $port_base_anuncio -f $anuncio`


                                        data=`date +"%Y-%m-%d %H:%M:S"`
                                        echo "${data}:${log_anuncio}" >> /var/log/log_envio.log

                                        sleep 10

                                        data_hora_ini_t=`date "+%Y-%m-%d %H:%M:%S"`

                                        echo "INSERT INTO tbl_transmissoes (cod_pacote,dt_hora_ini_transmissao,dt_hora_fim_transmissao) VALUES ('$cod_pacote','$data_hora_ini_t','0000-00-00 00:00:00')" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM

                                        #envia o pacote
                                        log_envio=`/usr/bin/udp-sender --async --ttl 64 --mcast-data-address $endereco_mcast --mcast-rdv-addr $endereco_mcast --autostart 1 --fec $fec --max-bitrate $bitrate --interface $interface --portbase $port_base_pacote -f $dir_pacotes/$rede_cliente/${rede_cliente}_${tarja_pacote}_update.tar.gz`
                                        echo $log_envio >> /var/log/log_envio.log

                                        data_hora_fim_t=`date "+%Y-%m-%d %H:%M:%S"`

                                        echo "UPDATE tbl_transmissoes set dt_hora_fim_transmissao='${data_hora_fim_t}' WHERE dt_hora_ini_transmissao='${data_hora_ini_t}'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM

                                        qtde_t=$((qtde_t+1))

                                        echo "UPDATE tbl_pacotes set qtde_transmissoes_efetuadas='$qtde_t' WHERE cod_pacote='$cod_pacote'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM
                                else
                                        data=`date +"%Y-%m-%d %H:%M:S"`
                                        echo "${data}:Algum parametro para efetuar a transmissao faltando." >> /var/log/log_envio.log
                                fi
                        else
                                data=`date +"%Y-%m-%d %H:%M:S"`
                                echo "${data}:Algum dado do pacote faltando." >> /var/log/log_envio.log
                        fi

                        #Fim carrossel pacotes do cliente

                        echo "UPDATE tbl_clientes set status_envio=0 WHERE cod_cliente='$cod_cliente'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM

                        valor=`echo "SELECT cod_cliente FROM tbl_clientes WHERE status=1 AND cod_cliente!='$cod_cliente' AND cod_cliente>'$cod_cliente' ORDER BY cod_cliente LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_cliente`

                        cod_cliente=`echo $valor | cut -d" " -f1`
                        #nome_cliente=`echo $valor | cut -d" " -f2`

                        if [ "$cod_cliente" != "" ]
                        then
                                #echo "Proximo cliente $nome_cliente codigo $cod_cliente selecionado para transmissao"
                                echo "UPDATE tbl_clientes set status_envio=1 WHERE cod_cliente='$cod_cliente'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM

                        else
                                valor=`echo "SELECT cod_cliente FROM tbl_clientes WHERE status=1 ORDER BY cod_cliente LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_cliente`
                                cod_cliente=`echo $valor | cut -d" " -f1`
                                #nome_cliente=`echo $valor | cut -d" " -f2`

                                echo "UPDATE tbl_clientes set status_envio=1 WHERE cod_cliente='$cod_cliente'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM
                        fi

                        sleep 2
                else
                        valor=`echo "SELECT cod_cliente FROM tbl_clientes WHERE status=1 ORDER BY cod_cliente LIMIT 1" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM | grep -v cod_cliente`
                        cod_cliente=`echo $valor | cut -d" " -f1`

                        echo "UPDATE tbl_clientes set status_envio=1 WHERE cod_cliente='$cod_cliente'" | mysql -h $server -u dtcom -p$senha CTRL_DTCOM
                fi
        else
                data=`date +"%Y-%m-%d %H:%M:S"`
                echo "${data}:Nenhum cliente ativo para transmissao." >> /var/log/log_envio.log
        fi
done

