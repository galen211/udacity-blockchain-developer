#!/bin/bash

rm -rf src/flutter_dapp/assets/contracts/*

ganache-cli \
-m "summer wolf absurd truck hire say exit impact below marriage exclude liberty" \
--defaultBalanceEther=1000 \
--accounts=100 \
--gasLimit=99999999 \
--account_keys_path=./src/flutter_dapp/assets/contracts/accounts.json