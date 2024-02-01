
# Multi Host Hyperledger Fabric Network 

This project is based on  `test-network` fabric sample, with some added code and logic, so it can be run on multiple hosts. This project executes the binary files without creating docker images, for faster deployment.

First commit was using cryptogen tool, while this one uses CAs and is more production ready.

Our network consists of three orgs (org1, org2, orderer), two of which have one peer each, while the third one has an orderer, each with its own CA. Org1 peer and orderer run on the first host (`distributed-machine-1` directory), while org2 peer runs on the second host (`distributed-machine-2` directory). 

## Prereqs

- Follow the Fabric documentation for the [Prereqs](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)
- Follow the Fabric documentation for [downloading the Fabric samples and binaries](https://hyperledger-fabric.readthedocs.io/en/latest/install.html). You can skip the docker image downloads by using `./install-fabric.sh binary samples`

The project directories should be placed inside fabric-samples folder or the binary files path should be edited.

## Starting the Network

In addition to starting the network components (CAs, orderers, peers, etc), certain files need to be transferred using an out-of-band process. 
#### General Flow
- Each host:
	- Starts its CAs
	- Enrolls his identities
	- Starts his peers/orderers
- Orderer gets all organizations' msp 
- Orderer creates genesis block of channel
- Each peer gets the genesis block
- Each peer joins the channel
- Organizations set anchor peers



#### Two host setup
My **machine1**'s IP address is `192.168.108.71`.
Using `grep -r '192.168.108.71' .` you can see all the occurences of the **machine1 IP**.
Using ` sed -i 's/192.168.108.71/YOUR_MACHINE_1_IP/g' *` you can replace all of them with your own machine1 IP address.



**Machine2**'s IP address is `192.168.108.74`.
Using `grep -r '192.168.108.74' .` you can see all the occurences of the **machine2 IP**.
Using ` sed -i 's/192.168.108.74/YOUR_MACHINE_1_IP/g' *` you can replace all of them with your own machine2 IP address.

Make sure the machines can ping each other, and the specified ports are open.


#### Starting first host

Navigate to the `distributed-machine-1` directory.
Using the following commands we start orderer and org1 peer: 
````shell
./authorities.sh
./peers.sh
````
These scripts take care of starting CAs, enrolling identities, and starting peers/orderers.

If everything was done correctly, you should now have a running peer and orderer on the first host.
All of the output is being redirected to logs directory. You can check there for errors.

#### Starting second host

Navigate to the `distributed-machine-2` directory.

Using the following commands we start org2 peer: 
````shell
./authorities.sh
./peers.sh
````
These scripts take care of starting CA, enrolling identities, and starting peer.

If everything was done correctly, you should now have a running peer on the second host.
Again, all of the output is being redirected to logs directory. You can check there for errors.




#### Necessary files
In order for an orderer to create the channel, a peer to join a channel, or to invoke the smart contract, several files must be present.
- Orderer needs admin-cert, tlsca-cert and ca-cert of all the organizations that take part in a channel, in order to create the genesis block for that specific channel. The paths of these files are declared inside the `configtx.yaml` file.

After the peers and orderers (on all hosts) have been started, the first host uses `getOrg2.sh` script, to get the necessary files from second host. Then first host executes the `chanel.sh` script, to create the genesis block, let peer from org1 join the channel, and create an anchor peer.  

Second host also needs some files from the first host. 
- Peer needs the genesis block so it can join the channel, and it needs the tlsca certificates of orderer and org1, in order to invoke the smart contract. 

Using the `getGenesis.sh` script, second host gets the genesis block and the tlsca certificates of orderer and endorsing organizations (org1 in our example) . Then second host executes the `chanel.sh` script,  to let peer from org2 join the channel, and create an anchor peer.  

After each running the `channel.sh` script, each host should have an anchor peer for its organization (host1 - org1, host2 - org2).


In order to use peer commands from terminal, do not forget to `source peer1org1.sh` or `source peer1org2.sh` depending on which host you are at!
##  Deploying Chaincode to the Network


The process of deploying chaincode to the network follows this logic:
- Each peer packages and installs the same chaincode.
- Each peer approves the chaincode for his organization.
- After all peers have approved the chaincode, one of the peers commits the chaincode to the network.
- All peers can now query and invoke the chaincode.

You can find all of the chaincode commands in the `chaincodeCommands.txt` file.

# Stopping the network

The script `stop.sh` stops all the Fabric components that are being executed.
