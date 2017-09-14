#!/usr/bin/env bash

trap 'kill -TERM $PID' TERM INT
rm -f /opt/jdownloader/JDownloader.jar.*
rm -f /opt/jdownloader/JDownloader.pid

# Check if JDownloader.jar exists, or if there is an interrupted update
if [ ! -f /opt/jdownloader/JDownloader.jar ] && [ -f /opt/jdownloader/tmp/update/self/JDU/JDownloader.jar ]; then
    cp /opt/jdownloader/tmp/update/self/JDU/JDownloader.jar /opt/jdownloader/
fi

# Execute VPN
if [ -f /etc/openvpn/config ] && [ -f /etc/openvpn/auth ]; then
    vpnconfigfile=`cat /etc/openvpn/config`
    vpnauthfile=`cat /etc/openvpn/auth`
    openvpn --config $vpnconfigfile --auth-user-pass $vpnauthfile --daemon
    wait $!
fi

# Execute JDownloader
java -Djava.awt.headless=true -jar /opt/jdownloader/JDownloader.jar &
PID=$!
wait $PID
wait $PID

# Debugging helper - if the container crashes, create a file called "jdownloader-block.txt" in the download folder
# The container will not terminate (and you can run "docker exec -it ... bash")
if [ -f /root/Downloads/jdownloader-block.txt ]; then
    sleep 1000000
fi

EXIT_STATUS=$?
