#!/bin/bash
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='plq1923gyajfkyrt7xwh0p7zmfrdnnfrx6gmzhj3qj'
VALIDATOR_ADDRESS='plqvaloper1923gyajfkyrt7xwh0p7zmfrdnnfrx6gmufltxr'
DELAY=1800*1 #in secs - how often restart the script 
WALLET_NAME=jb #don't need to change it
#NODE="tcp://127.0.0.1:33657" #don't need to change it

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo "YOUR_PASSWORD" | planqd tx distribution withdraw-rewards $(planqd keys show wallet --bech val -a) --commission --gas="1000000" --gas-adjustment="1.15" --gas-prices="30000000000aplanq" --chain-id planq_7070-2 --from wallet
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
#        BAL=$(planqd query bank balances YOUR_DELEGATOR_ADDRESS --chain-id planq_7070-2| awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(planqd query bank balances YOUR_DELEGATOR_ADDRESS --chain-id planq_7070-2 --output json | jq -r '.balances[] | select(.denom=="aplanq")' | jq -r .amount)
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aplanq\n"

       
        BAL=$(planqd query bank balances YOUR_DELEGATOR_ADDRESS --chain-id planq_7070-2 --output json | jq -r '.balances[] | select(.denom=="aplanq")' | jq -r .amount)
#        BAL=$(planqd query bank balances YOUR_DELEGATOR_ADDRESS --chain-id planq_7070-2 | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(($BAL-50000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aplanq\n"
        echo -e "Stake ALL 11111\n"
        if (( BAL > 900000 )); then
        echo "YOUR_PASSWORD" | planqd tx staking delegate YOUR_VALOPER_ADDRESS ${BAL}aplanq --from Wallet --chain-id planq_7070-2 --gas-adjustment 1.15 --gas=1000000 --gas-prices=30000000000aplanq 
        else
          echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} aplanq BAL < 900000 ((((\n"
        fi 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
