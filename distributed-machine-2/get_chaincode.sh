# Remove the old chaincode package and copy the packaged chaincode from machine1
rm -r "${PWD}"/basic.tar.gz || true 
scp isense@192.168.108.71:"/home/isense/fabric/fabric-samples/distributed/basic.tar.gz" /home/isense/fabric/fabric-samples/distributed/basic.tar.gz | tr -d '\r'
