#!/bin/bash

depto="serverdtcom"
ip="131.255.239.38"

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

# Sincronismo de scripts
rsync -azv --temp-dir=/tmp --timeout=180 --copy-links --delete-after --password-file=/etc/atualiza.update rsync://$depto@$ip:/$depto/ /usr/local/scripts 2>&1 | grep -qe 'atualiza.sh'

if [ $? -eq 0 -a -x /usr/local/scripts/atualiza.sh ]; then
    /usr/local/scripts/atualiza.sh
fi
