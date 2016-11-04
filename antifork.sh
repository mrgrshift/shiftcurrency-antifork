#!/bin/bash
#modified from original script on https://forum.lisk.io/viewtopic.php?t=395 by sgdias

#Adapted for screen sessions, save logs 

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

function run(){
	#star process.sh
	screen -dmS antifork bash -c '~/shiftcurrency-antifork/process.sh; exec bash'
	echo "antifork started in a detached screen.."
}

function stop(){
        screen -S antifork -p 0 -X stuff "^C"
#        screen -S antifork -p 0 -X stuff "exit$(printf \\r)"
	echo "antifork stopped"
}

show_log(){
  antifork_log_validation
  cat ~/shift/logs/antifork.log
  echo "--------------------------------------------------END"
}


case $1 in
"log")
	show_log
  ;;
"stop")
        stop
  ;;
"status")
        process=$(screen -ls | grep "antifork")
        if [[ -z $process ]]; then
          echo "antifork not running"
	else
	  echo "antifork running.."
        fi
  ;;
*)
	process=$(screen -ls | grep "antifork")
	if [[ -z $process ]]; then
	  run
	else
	  echo "Antifork already running."
	  echo "You can execute:"
	  echo "    bash antifork.sh log"
	  echo "    bash antifork.sh stop"
          echo "    bash antifork.sh status"
	fi
  ;;
esac
