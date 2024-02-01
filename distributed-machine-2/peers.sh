#!/bin/bash

export PATH=${PWD}/../bin:$PATH

. scripts/utils.sh


infoln "Starting peer0 org2"


mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/admincerts
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/admincerts/cert.pem


export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/
export FABRIC_CFG_PATH=${PWD}
export FABRIC_LOGGING_SPEC=INFO
#- FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=false
export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
# Peer specific variables
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=192.168.108.74:9051
export CORE_PEER_LISTENADDRESS=192.168.108.74:9051
export CORE_PEER_CHAINCODEADDRESS=192.168.108.74:9052
export CORE_PEER_CHAINCODELISTENADDRESS=192.168.108.74:9052
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=192.168.108.74:9051
export CORE_PEER_GOSSIP_BOOTSTRAP=192.168.108.74:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp
export CORE_OPERATIONS_LISTENADDRESS=192.168.108.74:9445
export CORE_METRICS_PROVIDER=prometheus
export CHAINCODE_AS_A_SERVICE_BUILDER_CONFIG={"peername":"peer0org2"}
export CORE_CHAINCODE_EXECUTETIMEOUT=300s
export CORE_PEER_FILESYSTEMPATH=/home/isense/hyperledger/peer0org2/production
export CORE_LEDGER_SNAPSHOTS_ROOTDIR=/home/isense/hyperledger/org2/peer0/data/snapshots

peer node start > logs/peer0-org2.log 2>&1 &


#export FABRIC_CFG_PATH=${PWD}
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=192.168.108.74:7051
export CORE_PEER_TLS_ENABLED=true
#configtxgen -profile ChannelUsingRaft -outputBlock ./channel-artifacts/mychannel.block -channelID mychannel