mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca

scp -r isense@192.168.108.71:/home/isense/fabric/fabric-samples/final1/channel-artifacts ${PWD}
mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/
scp -r isense@192.168.108.71:/home/isense/fabric/fabric-samples/final1/organizations/ordererOrganizations/example.com/tlsca ${PWD}/organizations/ordererOrganizations/example.com
scp -r isense@192.168.108.71:/home/isense/fabric/fabric-samples/final1/organizations/peerOrganizations/org1.example.com/tlsca ${PWD}/organizations/peerOrganizations/org1.example.com/