#!/bin/bash

#### USE 
# The use of this script is for bypass the access control to the network, where the network is monitored in its pre-admission phase.
# Execute  with root 
# Not required installmac changer
# THIS SCRIPT RECONNECT TO NETWORK !

### REQUIREMENTS  
# Required change INTERFACE AND NETWORK_NAME  values
# On NetWorkManager select automatic connect 

INTERFACE='...'; #put interface here
NETWORK_NAME='...'; #put networkname here
INTERVAL=30;

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
   
    echo "Changing hostname random :)..."
    
    FILE=/usr/share/dict/american-english
    WORD=$(sort -R $FILE | head -1)
    OLDHOST=$(hostname)
    hostname $WORD
    if [ $? == 0 ]; then
        echo "%sPrevius Hostname: $OLDHOST \n"
        echo "%sRandom Hostname: $WORD \n"
    else
            echo "%sScript encounter an error, sorry…\n"
    exit 1
    fi 
	
    echo '- Init  service  of NetworkManager ...';
    systemctl start network-manager

    echo "- Connect to : ${NETWORK_NAME} ...";
    nmcli con up id "${NETWORK_NAME}"

    echo "Finish him!  wait  ${INTERVAL} seconds ...";

    sleep $INTERVAL
done

