#!/bin/bash
#modified from original script on https://forum.lisk.io/viewtopic.php?t=395 by sgdias

#Adapted for screen sessions, save logs 

SHIFT_SCREEN="shift"
ANTIFORK_LOG=~/shift/logs/antifork.log

if [ ! -f ~/shift/app.js ]; then
  echo "Error: No shift installation detected. Exiting."
  exit 1
fi

function antifork_log_validation(){
	if [ ! -f $ANTIFORK_LOG ]; then
  	  NOW=$(date +"%d-%m-%Y")
  	  echo "Antifork-log $NOW" > $ANTIFORK_LOG
  	  echo "--------------------------------------------------" >> $ANTIFORK_LOG
	fi
}

echo "Antifork started.."

tail -Fn0 ~/shift/logs/shift.log |
while read line ; do

    echo "$line" | grep "Fork"
    if [ $? = 0 ]; then
	TIME=$(date +"%H:%M" -d '7 hours ago')
        echo "Fork found ($TIME): $line"
	antifork_log_validation
	echo "Fork found ($TIME): $line" >> $ANTIFORK_LOG
    fi

       echo "$line" | grep "\"cause\":2"
    if [ $? = 0 ]; then
        echo "Fork with root cause code 2 found. Restarting node main."
	echo "Auto restarting node..."
	antifork_log_validation
	echo "Fork cause : 2.. restarting node" >> $ANTIFORK_LOG
	#stop node app.js
	screen -S $SHIFT_SCREEN -p 0 -X stuff "^C"
	screen -S $SHIFT_SCREEN -p 0 -X stuff "node app.js$(printf \\r)"

        echo "Auto Restarting Done"
	echo "Auto Restarting Done" >> $ANTIFORK_LOG
    fi


done
