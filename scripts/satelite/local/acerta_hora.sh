#!/bin/bash
#Sincroniza a hora certa com o servidor Prof. Xavier
ntpdate 10.0.1.226
hwclock -w
