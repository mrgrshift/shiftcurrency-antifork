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


make_antifork_test(){
	echo "This test will enable forging and disable it into your extra synchronized server. This to ensure your delegate node is capable to do this commands."

        read -p "Do you want to continue (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
		echo " "
		echo -n "... "
		#curl -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL | grep "true"
		RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL`
		echo $RESPONSE | grep "true" > /dev/null
        	if [ $? = 0 ]; then
		  echo -e "${GREEN}Forging enabled successfully.${OFF}"
		  echo -n "... "
		  RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL_DISABLE`
		  echo $RESPONSE | grep "true" > /dev/null
		   if [ $? = 0 ]; then
			echo -e "${GREEN}Forging disabled successfully.${OFF}"
			echo " "
			echo " "
			echo "***Your installation is perfect!"
		   else
			echo -e "${RED}Error:${OFF} $RESPONSE"
			echo "Error in disabling forging, please disable forging manually to prevent future errors."
			echo " "
			echo " "
			echo "***Your installation is good, you can use failover."
		   fi
		else
		   echo " "
		   echo -e "${RED}Error:${OFF} $RESPONSE"
		   echo -e "${RED}***Something is wrong, please run again bash install.sh and make sure you have entered the right information.${OFF}"
		fi
           else
                echo " "
                echo "Tests for failover has been stopped."
           fi

	echo " "
	echo " "
        echo "The following test will send you an email."

        read -p "Do you want to continue (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
		echo " "
		LOCAL_TIME=$(date +"%H:%M" -d $OFFSET' hour')
		MG_SUBJECT="Test mail"
        	MG_TEXT="This mail is for you to check the functionality of alerts. Confirm your delegate name: $DELEGATE_NAME  Confirm your local time: $LOCAL_TIME"
		curl -s --user "api:$API_KEY" $MAILGUN -F from="$MG_FROM" -F to="$MG_TO" -F subject="$MG_SUBJECT" -F text="$MG_TEXT"
		echo " "
		echo "Do you recieve the email? if yes you have a perfect mailgun installation. If not please check your api configuration and check if you have authorized recipients."
	   else
		echo " "
		echo "Test for send email has been stopped."
	   fi
}


do_forge_off(){
	echo "This action will disable forging in this node and enable forging into your extra synchronized server."

        read -p "Do you want to continue (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
		echo " "
                RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL_LOCAL_DISABLE`
                echo $RESPONSE | grep "true" > /dev/null
                if [ $? = 0 ]; then
                   echo -e "${GREEN}Forging on localhost has been disabled.${OFF}"
                	RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL`
                	echo $RESPONSE | grep "true" > /dev/null
               		if [ $? = 0 ]; then
        	           echo -e "${GREEN}Forging in remote server enabled successfully.${OFF}"
 	                else
                	   echo -e "${RED}Error:${OFF} $RESPONSE"
        	           echo -e "${RED}***Something is wrong, please run again bash install.sh and make sure you have entered the right information.${OFF}"
                	   RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL_LOCAL`
                	   echo $RESPONSE | grep "true" > /dev/null
        	           if [ $? = 0 ]; then
	                      echo "Forging on localhost enabled."
			   else
			      echo "Check your localhost node. Please manually enable it."
			   fi
	                fi
                else
                   echo -e "${RED}Error:${OFF} $RESPONSE"
                   echo -e "${RED}***Something is wrong, please run again bash install.sh and make sure you have entered the right information.${OFF}"
                fi
	   else
		echo ".... forge_off action canceled."
	fi
}



do_forge_on(){
        echo "This action will disable forging in your extra synchronized server and enable forging in this node."

        read -p "Do you want to continue (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
                RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL_DISABLE`
                echo $RESPONSE | grep "true" > /dev/null
                if [ $? = 0 ]; then
                   echo -e "${GREEN}Forging on remote server has been disabled.${OFF}"
                        RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL_LOCAL`
                        echo $RESPONSE | grep "true" > /dev/null
                        if [ $? = 0 ]; then
                           echo -e "${GREEN}Forging on localhost enabled successfully.${OFF}"
                        else
                           echo -e "${RED}Error:${OFF} $RESPONSE"
                           echo -e "${RED}***Something is wrong, please run again bash install.sh and make sure you have entered the right information.${OFF}"
                           RESPONSE=`curl -s -k -H "Content-Type: application/json" -X POST -d "{\"secret\":\"$SECRET\"}" $URL`
                           echo $RESPONSE | grep "true" > /dev/null
                           if [ $? = 0 ]; then
                              echo "Forging on remote server enabled."
                           else
                              echo "Check your remote server node. Please manually enable it."
                           fi
                        fi
                else
                   echo -e "${RED}Error:${OFF} $RESPONSE"
                   echo -e "${RED}***Something is wrong, please run again bash install.sh and make sure you have entered the right information.${OFF}"
                fi
           else
                echo ".... forge_on action canceled."
        fi
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
"test")
	make_antifork_test
  ;;
"forge_off")
	do_forge_off
  ;;
"forge_on")
	do_forge_on
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
	  echo "    bash antifork.sh test       <-- you can test if your antifork will work"
	  echo "    bash antifork.sh forge_off  <-- will stop forging on main node and makes backup node take over"
	  echo "    bash antifork.sh forge_on   <-- will stop forging on backup node and makes main node take over"
	fi
  ;;
esac



#created by mrgr. Please consider to vote for mrgr delegates
