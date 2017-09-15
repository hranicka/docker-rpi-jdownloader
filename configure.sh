#!/bin/bash

usage="$(basename "$0") <email> <password>"

if [ ! $# -eq 2 ]; then
    echo "$usage"
    exit 1
fi

if [ ! -f /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json ]; then
    cp /opt/jdownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

if [ -f /opt/jdownloader/credentials ]; then
    cred=($(cat /opt/jdownloader/cfg/credentials))
    sed -i "s/\"password\" : \"${cred[1]}\",/\"password\" : \"$2\",/" /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json && \
    sed -i "s/\"email\" : \"${cred[0]}\"/\"email\" : \"$1\"/" /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
else
    sed -i "s/\"password\" : null,/\"password\" : \"$2\",/" /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json && \
    sed -i "s/\"email\" : null/\"email\" : \"$1\"/" /opt/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

echo -e "$1\n$2" > /opt/jdownloader/credentials
pkill -f "JDownloader"
