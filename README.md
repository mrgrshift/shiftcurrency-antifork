# shiftcurrency-antifork
Script to detect forks, create logs, fork-cause2 recovery, automate failover

#Requisites

	- You need to have an account in mailgun, and have authorized recipients.
	- If you want failover you need to have an extra syncronized server. 
		- In your backup server go to config.json and enter in whitelist (api & forging) the IP of the node you are backing up.

#Installation
```
cd ~/
git clone https://github.com/mrgrshift/shiftcurrency-antifork
cd shiftcurrency-antifork/
bash install.sh
```

