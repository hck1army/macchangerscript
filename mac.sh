#!/bin/bash

# Execute  with root 
# Not requrired installmacchanger

echo 'Listing Interfaces'
ls /sys/class/net/ | grep ^
echo 'Select and add your interface here! INT'
read INT
INTERFACE='"$INT"';
NETWORK_NAME='';
INTERVAL=5;

while true; do 
    hexchars="0123456789ABCDEF"
    end=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
    MAC=00$end

    echo 'Init process to change MAC ...';
    echo '- Stoping service of NetWorkManager ...'
    systemctl stop network-manager

    echo "- Assigning mac address (${MAC}) ...";
    ifconfig $INTERFACE down
    ifconfig $INTERFACE hw ether $MAC
    ifconfig $INTERFACE up

    echo '- Init  service  of NetworkManager ...';
    systemctl start network-manager

    echo "- Connect to : ${NETWORK_NAME} ...";
    nmcli con up id "${NETWORK_NAME}"

    echo "Finish him!  wait  ${INTERVAL} seconds ...";

    sleep $INTERVAL
done

