# shiftcurrency-antifork
Script to detect forks, create logs and fork-cause2 recovery, automate failover

#Requisites

	- You need to have an account in mailgun, and have authorized recipients.
	- If you want failover you need to have an extra syncroized server. In your node server go to config.json and enter in whitelist (API & Forge) the IP of your backup server.

#Installation
`git clone https://github.com/mrgrshift/shiftcurrency-antifork`
`bash install.sh`


