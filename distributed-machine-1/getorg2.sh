mkdir -p /home/isense/fabric/fabric-samples/final1/organizations/peerOrganizations/org2.example.com/msp/cacerts
mkdir -p /home/isense/fabric/fabric-samples/final1/organizations/peerOrganizations/org2.example.com/tlsca

scp -r isense@192.168.108.74:/home/isense/fabric/fabric-samples/final2/organizations/peerOrganizations/org2.example.com/msp /home/isense/fabric/fabric-samples/final1/organizations/peerOrganizations/org2.example.com/

scp -r isense@192.168.108.74:/home/isense/fabric/fabric-samples/final2/organizations/peerOrganizations/org2.example.com/tlsca /home/isense/fabric/fabric-samples/final1/organizations/peerOrganizations/org2.example.com/