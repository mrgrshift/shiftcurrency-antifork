#!/bin/bash

#created by mrgr. Please consider to vote for mrgr delegates


NOW=$(date +"%H:%M")
LOCAL_TIME=0
echo "----------------------------------------"
echo "Welcome to the antifork installation"
echo "Don't forget to vote for mrgr delegates"
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
	   echo "integers only"
	fi
done

echo "Your local time selected: $LOCAL_TIME"
echo " "
echo "Now we are going to configure the email settings. This works with mailgun.com"
echo "Please enter the following information:"
echo -n "Api key: "
	read API_KEY
echo -n "Email from (your Default SMTP Login):  "
	read MG_FROM
echo -n "Enter your API Base URL: "
	read MAILGUN
echo -n "Email to (to whom the mail is sent): "
	read MG_TO

        read -p "Is this information correct (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
		echo "Email information set. Alerts will sent to: $MG_TO"
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
echo -n "Insert the name of your delegate: "
	read DELEGATE_NAME
echo -n "Insert your delegate passphrase: "
	read SECRET

echo " "
echo -n "Now enter the name of the screen you're running shift: "
	read SCREEN_NAME

#antifork.sh
initfile=~/shiftcurrency-antifork/init.sh
processfile=~/shiftcurrency-antifork/antifork.sh
echo " "
echo "#!/bin/bash" > $processfile
echo "SHIFT_SCREEN=\"$SCREEN_NAME\"" >> $processfile
echo "API_KEY=\"$API_KEY\"" >> $processfile
echo "MG_FROM=\"$MG_FROM\"" >> $processfile
echo "MAILGUN=\"$MAILGUN/messages\"" >> $processfile
echo "MG_TO=\"$MG_TO\"" >> $processfile
echo "MG_SUBJECT=\"$DELEGATE_NAME in Fork - failover activated successfully\"" >> $processfile
echo "MG_TEXT=\"Description of the alert\"" >> $processfile
echo "DELEGATE_NAME=\"$DELEGATE_NAME\"" >> $processfile
echo "OFFSET=\"$scale\"" >> $processfile
echo "IP_SERVER=\"$IP_SERVER\"" >> $processfile
echo "HTTP=\"$HTTP\"" >> $processfile
echo "PORT=\"$PORT\"" >> $processfile
echo "SECRET=\"$SECRET\"" >> $processfile
echo "URL=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/enable\"" >> $processfile
echo "URL_DISABLE=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/disable\"" >> $processfile

cat $initfile >>  $processfile


#process.sh
initfile=~/shiftcurrency-antifork/proc.sh
processfile=~/shiftcurrency-antifork/process.sh

echo " "
echo "#!/bin/bash" > $processfile
echo "SHIFT_SCREEN=\"$SCREEN_NAME\"" >> $processfile
echo "API_KEY=\"$API_KEY\"" >> $processfile
echo "MG_FROM=\"$MG_FROM\"" >> $processfile
echo "MAILGUN=\"$MAILGUN/messages\"" >> $processfile
echo "MG_TO=\"$MG_TO\"" >> $processfile
echo "MG_SUBJECT=\"$DELEGATE_NAME in Fork - failover activated successfully\"" >> $processfile
echo "MG_TEXT=\"Description of the alert\"" >> $processfile
echo "DELEGATE_NAME=\"$DELEGATE_NAME\"" >> $processfile
echo "OFFSET=\"$scale\"" >> $processfile
echo "IP_SERVER=\"$IP_SERVER\"" >> $processfile
echo "HTTP=\"$HTTP\"" >> $processfile
echo "PORT=\"$PORT\"" >> $processfile
echo "SECRET=\"$SECRET\"" >> $processfile
echo "URL=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/enable\"" >> $processfile
echo "URL_DISABLE=\"$HTTP://$IP_SERVER:$PORT/api/delegates/forging/disable\"" >> $processfile

cat $initfile >>  $processfile

chmod u+x ~/shiftcurrency-antifork/process.sh

echo " "
echo "**********************ALL SET"
echo " "
read -p "Do you want to run the antifork script (y/n)?" -n 1 -r
        if [[  $REPLY =~ ^[Yy]$ ]]
           then
                echo " "
		bash antifork.sh
	   else
		echo " "
		echo "To start Run : bash antifork.sh"
           fi
echo " "
echo " "
echo "If you want to check if your installation is complete please execute: bash antifork.sh test"



#created by mrgr. Please consider to vote for mrgr delegates
