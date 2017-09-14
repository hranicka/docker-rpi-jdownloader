#!/bin/bash

usage="$(basename "$0") <config file> <auth file>"

if [ ! $# -eq 2 ]; then
    echo "$usage"
    exit 1
fi

configdir="/etc/openvpn"
echo -e "$configdir/$1" > $configdir/config
echo -e "$configdir/$2" > $configdir/auth

pkill -f "JDownloader"
pkill -f "openvpn"
