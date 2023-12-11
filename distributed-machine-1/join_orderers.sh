#!/usr/bin/env sh

set -eu

export PATH="${PWD}"/../../fabric/build/bin:"${PWD}"/../bin:"$PATH"
export FABRIC_CFG_PATH="${PWD}"/../config

ORDERER_CONSENSUS_TYPE="etcdraft"
if [ $# -gt 0 ]
then
    if [ "$1" != "BFT" ] && [ "$1" != "etcdraft" ]
    then
        echo "Unsupported input consensus type ${1}"
        exit 1
    fi
    if [ "$1" = "BFT" ]
    then
      ORDERER_CONSENSUS_TYPE="BFT"
    fi
fi

osnadmin channel join --channelID mychannel --config-block ./channel-artifacts/mychannel.block -o 192.168.108.71:9443
osnadmin channel join --channelID mychannel --config-block ./channel-artifacts/mychannel.block -o 192.168.108.71:9444
#echo 'before'
#osnadmin channel join --channelID mychannel --config-block ./channel-artifacts/mychannel.block -o 192.168.108.71:9445
#echo 'after'

if [ "$ORDERER_CONSENSUS_TYPE" = "BFT" ]; then
  osnadmin channel join --channelID mychannel --config-block ./channel-artifacts/mychannel.block -o localhost:9446
fi
