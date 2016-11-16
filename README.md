# shiftcurrency-antifork
Script to detect forks, create logs, fork-cause2 recovery, automate failover, detect reboots, start at boot node app.js, manual take-over

#Requisites

	- You need to have an account in mailgun, and have authorized recipients.
	- If you want failover you need to have an extra synchronized server. 
		- In this extra synchronized server go to config.json and enter in whitelist (api & forging) the IP of the node you are backing up.
		- In this extra synchronized server after you edit config.json please restart your node app.js to activate the edited config.json

#Installation
Execute the following commands on your delegate node server
```
cd ~/
git clone https://github.com/mrgrshift/shiftcurrency-antifork
cd shiftcurrency-antifork/
bash install.sh
```

#Usage
`bash antifork.sh` Will open a new 'screen' session called antifork. This session will be alert and looking for Forks.<br>
<br>
`bash antifork.sh stop` Will close the antifork 'screen' session. This way you are turning off the antifork on your localhost.<br>
<br>
`bash antifork.sh test` You can use this command to test the antifork functionality. First will test the ability of Forging (enable and disable). Then will test the ability of send email.<br>
<br>
<b>Manual take-over</b><br>
In case you want to do maintenance on your main node or when you know the vps provider will do a reboot or maintenance you can switch over manually to make the backup node forge.<br>
Following commands must be made in main node:<br>
`bash antifork.sh forge_off` Will stop forging on main node and makes backup node take over<br>
`bash antifork.sh forge_on`  Will stop forging on backup node and makes main node take over<br>

<br>
<br>
--------------------------------------------------------------
###Notice
Although the script works, it is still in the testing phase, please use with caution.<br>
The only bad points we could find is that the commands are not executed properly and you have to manually check if your node is forging.
