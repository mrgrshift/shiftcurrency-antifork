#!/bin/bash



#created by mrgr. Please consider to vote for mrgr delegates




RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
OFF='\033[0m' # No Color

NOW=$(date +"%H:%M")
LOCAL_TIME=0
echo "----------------------------------------"
echo "Welcome to the antifork installation"
echo -e "Don't forget to vote for ${YELLOW}mrgr${OFF} delegates"
echo "----------------------------------------"
echo "Now we will set some variables."
echo "** If at any point you want to change this, run this installer again."
echo " "
echo "This is the local time from your server: $NOW"
OK=0
while [ $OK -eq 0 ]; do
echo -n "Please write the difference in hours from your local time:  "
	read scale
	if [[ $scale =~ ^[-+]?[0-9]+$  ]]; then
	   LOCAL_TIME=$(date +"%H:%M" -d $scale' hour')
	   read -p "This is your local time : $LOCAL_TIME (y/n)?" -n 1 -r
	   if [[  $REPLY =~ ^[Yy]$ ]]
	   then
		OK=1
		echo " "
		echo "Local time setted."
	   else
		echo " "
	   fi
	else
	   echo -e "${RED}Error:${OFF} Integers only"
	fi
done

echo "Your local time selected: $LOCAL_TIME"
echo " "
echo "Now we are going to configure the email settings. This works with mailgun.com"
echo "Please enter the following information:"
echo -n "Api key: "
	read API_KEY
echo -n "Default SMTP Login:  "
	read MG_FROM
echo -n "API Base URL: "
	read MAILGUN
echo -n "Email to: "
	read MG_TO

        read -p "Is this information correct (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
		echo -e "Email information set. Alerts will sent to: $MG_TO"
           else
                echo " "
		echo "Please run again the installer"
		exit 1
           fi

echo " "
echo "Now we are going to configure the failover settings."
echo "Please enter the folling information (of your extra syncronized server): "
echo -n "IP: "
	read IP_SERVER
HTTP="0"
PORT="0"
read -p "Is https enabled (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
		PORT="9306"
		HTTP="https"
	   else
		PORT="9305"
		HTTP="http"
           fi
echo " "
echo " "
echo "Now enter the information of your delegate."
echo -n "Delegate name: "
	read DELEGATE_NAME
echo -n "Delegate passphrase: "
	read SECRET

echo " "
echo -n "Now enter the name of the screen you're running shift: "
	read SCREEN_NAME


init=~/shiftcurrency-antifork/config.sh
echo " "
echo "#Config file" > $init
echo "#Shift antifork variables" >> $init
echo "RED='\033[1;31m'" >> $init
echo "YELLOW='\033[1;33m'">> $init
echo "GREEN='\033[1;32m'" >> $init
echo "CYAN='\033[1;36m'" >> $init
echo "OFF='\033[0m' # No Color" >> $init
echo "SHIFT_SCREEN=\"$SCREEN_NAME\" #name of the screen you are running shift" >> $init
echo "API_KEY=\"$API_KEY\" #your mailgun API key" >> $init
echo "MG_FROM=\"$MG_FROM\" #Default SMTP Login" >> $init
echo "MAILGUN=\"$MAILGUN/messages\" #API Base URL" >> $init
echo "MG_TO=\"$MG_TO\" #Email to" >> $init
echo "MG_SUBJECT=\"$DELEGATE_NAME in Fork - failover activated successfully\"" >> $init
echo "MG_TEXT=\"Description of the alert\"" >> $init
echo "DELEGATE_NAME=\"$DELEGATE_NAME\"" >> $init
echo "OFFSET=\"$scale\"" >> $init
echo "IP_SERVER=\"$IP_SERVER\" #IP of the extra syncronized server" >> $init
echo "HTTP=\"$HTTP\" #http or https if is activated" >> $init
echo "PORT=\"$PORT\" #9306 or 9306 if is activated" >> $init
echo "SECRET=\"$SECRET\" #Passphrase of DELEGATE_NAME" >> $init
echo "URL=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/enable\" #URL according variables HTTP, PORT and IP_SERVER" >> $init
echo "URL_DISABLE=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/disable\"" >> $init
echo "ANTIFORK_LOG=~/shift/logs/antifork.log" >> $init
echo "ANTIFORK_COUNT=~/shift/logs/antifork_count.log" >> $init

chmod u+x ~/shiftcurrency-antifork/process.sh

echo " "
echo -e "${CYAN}ALL VARIABLES SET${OFF}"
echo " "
read -p "Do you want to run the antifork script (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
		bash antifork.sh
	   else
		echo " "
		echo -e "To start Run : ${CYAN}bash antifork.sh${OFF}"
           fi
echo " "
echo " "
echo -e "If you want to check if your installation is complete please execute: ${CYAN}bash antifork.sh test${OFF}"
echo -e "If you want to change any of the variables edit the file ${CYAN}config.sh${OFF}"
echo " "
echo " "
echo " "

#REBOOT DETECT/STARTUP SCRIPT
echo "=============================================================="
echo "Anti-Reboot configuration"
echo "=============================================================="
echo " "
echo -e "Is important to keep ${CYAN}node app.js${OFF} running, that is why we need to prevent possible reboots or system outages."
echo "This script will send you an email alert when reboot is detected."
echo -e "Before proceeding, be sure to read the information located here: ${CYAN}https://github.com/mrgrshift/restart-script${OFF}"
echo " "
read -p "Do you want to proceed (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
		echo "The following configuration  will change your rc.local and your K99_script."
		echo "You need to select how this script will work:"
		echo "1) Before reboot the script will switch over forging to backup server."
		echo "2) At reboot the script will NOT switch over forging to backup server but will restart forging on main server."
		echo -n "Which option you will choose?: "
		OK=0
		while [ $OK -eq 0 ]; do
        	   read number
        	   if [[ $number =~ ^[+]?[1-2]+$  ]]; then
			OK=1
        	      if [[  $number -eq 1 ]]
        	      then
        	           echo "You selected option 1."
			   echo -n "Configuring... "
			   echo "#!/bin/sh" >  /etc/rc6.d/K99_script
			   echo "source $(pwd)/config.sh" >> /etc/rc6.d/K99_script
			   echo "curl -k -H \"Content-Type: application/json\" -X POST -d \"{\\"secret\\":\\"$SECRET\\"}\" $URL | grep \"true\"" >> /etc/rc6.d/K99_script
                	   echo "if [ $? = 0 ]; then" >> /etc/rc6.d/K99_script
			   echo "failover_result=\"successfully executed\"" >> /etc/rc6.d/K99_script
			   echo "else" >> /etc/rc6.d/K99_script
			   echo "failover_result=\"error not executed\"" >> /etc/rc6.d/K99_script
			   echo "fi" >> /etc/rc6.d/K99_script
			   echo "MG_SUBJECT=\"$DELEGATE_NAME rebooting. Failover $failover_result $LOCAL_TIME\"" >> /etc/rc6.d/K99_script
                	   echo "MG_TEXT=\"$DELEGATE_NAME rebooting. Failover $failover_result $LOCAL_TIME\"" >> /etc/rc6.d/K99_script
                	   echo "curl -s --user \"api:$API_KEY\" $MAILGUN -F from=\"$MG_FROM\" -F to=\"$MG_TO\" -F subject=\"$MG_SUBJECT\" -F text=\"$MG_TEXT\"" >> /etc/rc6.d/K99_script
			   echo "exit 0" >> /etc/rc6.d/K99_script
			   sudo chmod +x /etc/rc6.d/K99_script
			   echo "done"
        	      else
                           echo "You select 2."
                           echo -n "Configuring... "
                           echo "#!/bin/sh" >  /etc/rc6.d/K99_script
                           echo "source $(pwd)/config.sh" >> /etc/rc6.d/K99_script
                           echo "MG_SUBJECT=\"$DELEGATE_NAME rebooting. No Failover selected $LOCAL_TIME\"" >> /etc/rc6.d/K99_script
                           echo "MG_TEXT=\"$DELEGATE_NAME rebooting. No Failover selected $LOCAL_TIME\"" >> /etc/rc6.d/K99_script
                           echo "curl -s --user \"api:$API_KEY\" $MAILGUN -F from=\"$MG_FROM\" -F to=\"$MG_TO\" -F subject=\"$MG_SUBJECT\" -F text=\"$MG_TEXT\"" >> /etc/rc6.d/K99_script
                           echo "exit 0" >> /etc/rc6.d/K99_script
                           sudo chmod +x /etc/rc6.d/K99_script

				#startup script
				echo "#!/bin/bash" > startup.sh
				echo "export HOME=$(pwd)/../shift/" >> startup.sh
				echo "cd $(pwd)/../shift/" >> startup.sh
				echo "node $(pwd)/../shift/app.js" >> startup.sh
				sudo chmod u+x startup.sh
				echo "echo \"#!/bin/sh -e\" > /etc/rc.local | sudo tee -a /etc/rc.local > /dev/null" > temp.sh
				echo "echo \"/bin/su $USER -c \\\"cd $(pwd); /usr/bin/screen -dmS shift bash -c $(pwd)/startup.sh'; exec bash'\\\" >> /etc/rc.local\" | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh 
				echo "echo \"exit 0\" >> /etc/rc.local | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				sudo bash temp.sh
				echo -e "done.";
				rm temp.sh
			   echo "done"
        	      fi
        	   else
        	      echo -n -e "${RED}Error:${OFF} Select ${CYAN}1${OFF} or ${CYAN}2${OFF}: "
        	   fi
		done

		read -p "Are you in Ubuntu 14.04 (y/n)?" -n 1 -r
		        if [[  $REPLY =~ ^[Nn]$ ]]
		           then
				echo -n "Configuring newer version... "
				echo "echo \"[Unit]\" > /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" > temp.sh
				echo "echo \" Description=/etc/rc.local Compatibility\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" ConditionPathExists=/etc/rc.local\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh

				echo "echo \"[Service]\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" Type=forking\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" ExecStart=/etc/rc.local start\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" TimeoutSec=0\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" StandardOutput=tty\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" RemainAfterExit=yes\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" SysVStartPriority=99\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh

				echo "echo \"[Install]\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				echo "echo \" WantedBy=multi-user.target\" >> /etc/systemd/system/rc-local.service | sudo tee -a /etc/rc.local > /dev/null" >> temp.sh
				sudo bash temp.sh
				sudo chmod +x /etc/rc.local
				sudo systemctl enable rc-local
				sudo systemctl start rc-local.service
				echo "done"
				rm temp.sh
			fi

           else
                echo " "
		echo "The installation is over."
		exit 1
           fi

echo " "
echo "You have completed the installation."

#created by mrgr. Please consider to vote for mrgr delegates
