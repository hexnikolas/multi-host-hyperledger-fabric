#!/bin/bash

export PATH=${PWD}/../bin:$PATH

. scripts/utils.sh

infoln "Staring orderer"

mkdir -p  ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/admincerts
cp  ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem  ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/admincerts/cert.pem




export FABRIC_LOGGING_SPEC=INFO
export ORDERER_GENERAL_LISTENADDRESS=192.168.108.71
export ORDERER_GENERAL_LISTENPORT=7050
export ORDERER_GENERAL_LOCALMSPID=OrdererMSP
export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp
# enabled TLS
export ORDERER_GENERAL_TLS_ENABLED=true
export ORDERER_GENERAL_TLS_PRIVATEKEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_TLS_ROOTCAS=[${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt]
export ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_CLUSTER_ROOTCAS=[${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt]
export ORDERER_GENERAL_BOOTSTRAPMETHOD=none
export ORDERER_CHANNELPARTICIPATION_ENABLED=true
export ORDERER_ADMIN_TLS_ENABLED=true
export ORDERER_ADMIN_TLS_CERTIFICATE=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATEKEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_ADMIN_TLS_ROOTCAS=[${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt]
export ORDERER_ADMIN_TLS_CLIENTROOTCAS=[${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt]
export ORDERER_ADMIN_LISTENADDRESS=192.168.108.71:7053
export ORDERER_OPERATIONS_LISTENADDRESS=192.168.108.71:9443
export ORDERER_METRICS_PROVIDER=prometheus

orderer > logs/orderer.log 2>&1 &






infoln "Starting peer0 org1"

mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/admincerts
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/cert.pem ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/admincerts/cert.pem


export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/
export FABRIC_CFG_PATH=${PWD}
export FABRIC_LOGGING_SPEC=INFO
#export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=false
export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
      # Peer specific variables
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=192.168.108.71:7051
export CORE_PEER_LISTENADDRESS=192.168.108.71:7051
export CORE_PEER_CHAINCODEADDRESS=192.168.108.71:7052
export CORE_PEER_CHAINCODELISTENADDRESS=192.168.108.71:7052
export CORE_PEER_GOSSIP_BOOTSTRAP=192.168.108.71:7051
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=192.168.108.71:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp
export CORE_OPERATIONS_LISTENADDRESS=192.168.108.71:9444
export CORE_METRICS_PROVIDER=prometheus
export CHAINCODE_AS_A_SERVICE_BUILDER_CONFIG={"peername":"peer0org1"}
export CORE_CHAINCODE_EXECUTETIMEOUT=300s
export CORE_PEER_FILESYSTEMPATH=/home/isense/hyperledger/peer0org1/production
export CORE_LEDGER_SNAPSHOTS_ROOTDIR=/home/isense/hyperledger/org1/peer0/data/snapshots

peer node start > logs/peer0-org1.log 2>&1 &

