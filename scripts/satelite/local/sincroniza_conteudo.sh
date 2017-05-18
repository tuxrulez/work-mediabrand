#!/bin/bash
hora=`date '+%Y%m%d-%H%M'`
rede=$1

#--copy-links
#--delete-after

if [ "$rede" == "mercantil_rodrigues_mobox" -o "$rede" == "prezunic_mobox" ]; then

	(cd /local/tv/$rede/; rm -vrf scripts)
	(cd /tmp; rm -vrf $rede)
        /usr/bin/rsync -av  --timeout=180 --delete-after --password-file=/etc/tv.update rsync://${rede}@10.0.1.226:/${rede}/generos/ /local/tv/${rede}/generos >> logs/$rede.$hora.log &
        /usr/bin/rsync -av  --timeout=180 --delete-after --password-file=/etc/tv.update rsync://${rede}@10.0.1.226:/${rede}/scripts/ /local/tv/${rede}/scripts >> logs/$rede.$hora.log &

else

if [ "$rede" != "" ]
then
        /usr/bin/rsync -av  --timeout=180 --delete-after --password-file=/etc/tv.update rsync://${rede}@10.0.1.226:/${rede}/generos/ /local/tv/${rede}/generos >> logs/$rede.$hora.log &
        /usr/bin/rsync -av  --timeout=180 --delete-after --password-file=/etc/tv.update rsync://${rede}@10.0.1.226:/${rede}/scripts/ /local/tv/${rede}/scripts >> logs/$rede.$hora.log &
else
        echo "informar rede"
fi
fi
