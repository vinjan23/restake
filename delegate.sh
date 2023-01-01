#!/bin/bash

############ START - SET PROPERTIES #########

ADDRESS="<plq1...>"
VALIDATOR="<plqvaloper1...>"
KEY_NAME="<key_name>"
PWD="<wallet_password>"

CHAIN_ID="<chain-id>" #for mainnet: planq_7070-2
GAS_VALUE="<gas_value>" #for example: 30000000000 or auto
FEE_VALUE="<fee_value>" #for example: 1000000aplanq

############ END - SET PROPERTIES #########

############ START - AUTO DELEGATION #########

# Withdraw 
planqd tx distribution withdraw-rewards "${VALIDATOR}" --commission --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --fees="${FEE_VALUE}" -y

sleep 10s

AVAILABLE_COIN=$(planqd query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "aplanq")) | .[].amount' | tr -cd [:digit:])
KEEP_FOR_FEES=1000000
AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
AMOUNT_FINAL=$AMOUNT"aplanq"

sleep 10s

# Delegate
planqd tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --fees="${FEE_VALUE}" -y

echo $PWD | planqd tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --fees="${FEE_VALUE}" -y

############ END - AUTO DELEGATION #########
