#!/bin/bash



#created by mrgr. Please consider to vote for mrgr delegates



if [ ! -f config.sh ]; then
  echo "Error: Can't execute antifork. First run: bash install.sh"
  exit 1
fi

source config.sh

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
	if [ ! -f $ANTIFORK_COUNT ]; then
	  echo "0" > $ANTIFORK_COUNT
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
	counter=$(<$ANTIFORK_COUNT)
	((counter++))
	echo counter > $ANTIFORK_COUNT
	LOCAL_TIME=$(date +"%H:%M" -d $OFFSET' hour')

       echo "$line" | grep "\"cause\":2"
    	if [ $? = 0 ]; then
        	echo "Fork with root cause code 2 found. Restarting node main."
        	echo "Auto restarting node..."
        	echo "Fork cause : 2.. restarting node" >> $ANTIFORK_LOG
        	#stop node app.js
        	screen -S $SHIFT_SCREEN -p 0 -X stuff "^C"
        	screen -S $SHIFT_SCREEN -p 0 -X stuff "node app.js$(printf \\r)"

        	echo "Auto Restarting Done"
        	echo "Auto Restarting Done" >> $ANTIFORK_LOG
        	MG_SUBJECT="$DELEGATE_NAME in Fork cause 2, restarted successfully. $LOCAL_TIME"
        	MG_TEXT="$DELEGATE_NAME in Fork cause 2, restarted successfuly. $LOCAL_TIME Message: $line"
        	curl -s --user "api:$API_KEY" $MAILGUN -F from="$MG_FROM" -F to="$MG_TO" -F subject="$MG_SUBJECT" -F text="$MG_TEXT"
    	else
		echo "Starting failover..."
                echo "Starting failover..." >> $ANTIFORK_LOG

        	curl -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL | grep "true"
        	if [ $? = 0 ]; then
                   #stop node app.js
                   screen -S $SHIFT_SCREEN -p 0 -X stuff "^C"
                   echo -e "${GREEN}Failover successfully done${OFF}"
		   echo "Shift node app.js stopped."
                   echo "Failover successfully done. Shift node app.js stopped" >> $ANTIFORK_LOG

        	   MG_SUBJECT="$DELEGATE_NAME in Fork - Failover activated successfully. $LOCAL_TIME"
        	   MG_TEXT="$DELEGATE_NAME in Fork: $line - $LOCAL_TIME Failover activated successfully. And shift node app.js has been stopped."
        	else
		   echo -e "${RED}Failover not activated!${OFF}"
                   echo "Failover not activated!" >> $ANTIFORK_LOG
        	   MG_SUBJECT="$DELEGATE_NAME in Fork - Failover ERROR! not activated. $LOCAL_TIME"
        	   MG_TEXT="$DELEGATE_NAME in Fork: $line - $LOCAL_TIME Failover ERROR not activated."
        	fi

        	curl -s --user "api:$API_KEY" $MAILGUN -F from="$MG_FROM" -F to="$MG_TO" -F subject="$MG_SUBJECT" -F text="$MG_TEXT"
	    fi
    fi

done



#created by mrgr. Please consider to vote for mrgr delegates
