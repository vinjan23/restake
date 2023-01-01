#!/bin/bash

############ START - SET PROPERTIES #########

ADDRESS="<plq...>"
VALIDATOR="<plqvaloper...>"
KEY_NAME="<key_name>"
PWD="<wallet_password>"

CHAIN_ID="<chain-id>" #for mainnet: stargaze-1
GAS_PRICE="<price_value>" #for example: 200000 or auto
GAS="<gas_value>" #for example: 200ustars
GAS_ADJUSMENT="<value>"

############ END - SET PROPERTIES #########

############ START - AUTO DELEGATION #########

# Withdraw 
planqd tx distribution withdraw-rewards "${VALIDATOR}" --commission --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas-price="${PRICE_VALUE}" --gas="${GAS_VALUE}" --gas-adjustment="$(VALUE)

sleep 10s

AVAILABLE_COIN=$(planqd query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "ustars")) | .[].amount' | tr -cd [:digit:])
KEEP_FOR_GAS=1000000
AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_GAS))
AMOUNT_FINAL=$AMOUNT"aplanq"

sleep 10s

# Delegate
planqd tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --gas-price="${PRICE_VALUE}" --gas-adjustment="$(VALUE)

echo $PWD | planqd tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --gas-price="${PRICE_VALUE}" --gas-adjustment="$(VALUE)

############ END - AUTO DELEGATION #########
