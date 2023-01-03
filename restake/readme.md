###  Update package
```
sudo apt update && \
sudo apt upgrade
```

### Install Docker & Docker Compose
```
sudo apt-get update && sudo apt install jq && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin && sudo apt-get install docker-compose-plugin
```

### Setup a New wallet `Use new Wallet not Main Wallet` & `Save Mnemonic Phrase`

### Build
```
git clone https://github.com/eco-stake/restake
cd restake
npm install
cp .env.sample .env
nano .env
```
`Input New Mnemonic Phrase`

`Crtl X + Y Enter`

###
```
git pull
docker-compose run --rm app npm install
docker-compose build --no-cache
docker-compose run --rm app npm run autostake
```

### Setting up Cron/Timers to run the script on a schedule
`Only Each Day`

```
crontab -e
```
```
0 21 * * * /bin/bash -c "cd restake && docker compose run --rm app npm run autostake" > ./restake.log 2>&1
```
`Crtl X + Y Enter`

### Create a systemd unit file
```
nano /etc/systemd/system/restake.service
```
```
[Unit]
Description=restake service with docker compose
Requires=docker.service
After=docker.service
Wants=restake.timer

[Service]
Type=oneshot
WorkingDirectory=/path/to/restake
ExecStart=/usr/bin/docker-compose run --rm app npm run autostake

[Install]
WantedBy=multi-user.target
```

### Create a systemd timer file
```
nano /etc/systemd/system/restake.timer
```
```
[Unit]
Description=Restake bot timer

[Timer]
AccuracySec=1min
OnCalendar=*-*-* 21:00:00

[Install]
WantedBy=timers.target
```

### Start Service
```
systemctl enable restake.service
systemctl enable restake.timer
systemctl start restake.timer
```
### check Service
```
systemctl status restake.service
```

### Check Timer
```
systemctl status restake.timer
```


### Customise ReStake
`
/root/restake/src/`

`Add network.json` `Edit ownerAddress`
```
{
    "name": "planq",
    "prettyName": "planq",
    "gasPrice": "30000000000aplanq",
    "ownerAddress": plqvaloper,,,,,,,,,
  },
  ```
  
`Add Network.local.json`
```
{
  "planq": {
    "prettyName": "planq",
    "restUrl": [
      "https://rest.cosmos.directory/planq"
    ],
    "gasPrice": "30000000000aplang",
    "autostake": {
      "retries": 3,
      "batchPageSize": 100,
      "batchQueries": 25,
      "batchTxs": 50,
      "delegationsTimeout": 20000,
      "queryTimeout": 5000,
      "queryThrottle": 100,
      "gasModifier": 1.1
    },
    "healthCheck": {
      "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
    }
  },
  "planq": {
    "prettyName": "planq",
    "autostake": {
      "correctSlip44": true
    }
  },
  "cosmoshub": {
    "enabled": false
  }
}
```






