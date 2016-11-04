# shiftcurrency-antifork
Script to detect forks, create logs, fork-cause2 recovery, automate failover

#Requisites

	- You need to have an account in mailgun, and have authorized recipients.
	- If you want failover you need to have an extra syncronized server. 
		- In this extra syncronized server go to config.json and enter in whitelist (api & forging) the IP of the node you are backing up.
		- In this extra syncronized server after you edit config.json please restart your node app.js to activate the edited config.json

#Installation
Execute the following commands on your delegate node server
```
cd ~/
git clone https://github.com/mrgrshift/shiftcurrency-antifork
cd shiftcurrency-antifork/
bash install.sh
```

