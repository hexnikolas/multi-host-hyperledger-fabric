# Copy the crypto config and the genesis block from machine1

# Remove old directories
rm -r "${PWD}"/crypto-config || true
rm -r "${PWD}"/channel-artifacts || true
rm -r "${PWD}"/data || true
rm -r "${PWD}"/logs || true

# Copy the two directories from machine1
# Instead of using two scp commands, and entering the login password twice, we use this approach instead
# where we login using ssh, create a compressed archive of the two directories (crypto-config and channel-artifacts), and extract it on machine2
ssh isense@192.168.108.71 "tar -czC /home/isense/fabric/fabric-samples/distributed/ crypto-config channel-artifacts" | tar -xzC /home/isense/fabric/fabric-samples/distributed/
