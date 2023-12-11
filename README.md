
# Multi Host Hyperledger Fabric Network 

This project is based on  `Test network - Nano bash` fabric sample, with some added code to be run on multiple hosts.

Test network Nano bash provides a set of minimal bash scripts to run a Fabric network on your local machine.
The network is functionally equivalent to the docker-based Test Network, you can therefore run all the tutorials and samples that target the Test Network with minimal changes.
The Fabric release binaries are utilized rather than using docker containers to avoid all unnecessary layers. And you can choose between running the chaincode and chaincode builder in a docker container behind the scenes or running the chaincode as a service without any containers at all.
Using the Fabric binaries also makes it simple for Fabric developers to iteratively and quickly modify Fabric code and test a Fabric network as a user.

As the name `nano` implies, the scripts provide the smallest minimal setup possible for a Fabric network while still offering a multi-node TLS-enabled network:
- Minimal set of dependencies
- Minimal requirements on Fabric version (any v2.x orderer and peer nodes should work)
- Minimal set of environment variable overrides of the default orderer orderer.yaml and peer core.yaml configurations
- Minimal scripting with minimal set of reference commands to get a Fabric network up and running
- Minimal channel configuration for an orderer organization (3 ordering nodes) and two peer organizations (with two peers each)
- Minimal endorsement policy to allow a single organization to approve and commit a chaincode (unlike Test Network which requires both organizations to endorse)

## Prereqs

- Follow the Fabric documentation for the [Prereqs](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)
- Follow the Fabric documentation for [downloading the Fabric samples and binaries](https://hyperledger-fabric.readthedocs.io/en/latest/install.html). You can skip the docker image downloads by using `./install-fabric.sh binary samples`



## Instructions for starting network

Download the project, and place the two directories, `distributed-machine-1`, `distributed-machine-2` inside the fabric-samples directory on the two machines. 
The instructions of this project focus on two machines, but more can be added easily.

The network consists of three orgs with one peer each (org1,org2,org3), and 3 orderers.
Machine1 hosts the orderers and the two peers from org1 and org2, while machine2 hosts the peer from org3.


### First machine setup
Navigate to the `distributed-machine-1` directory.

In my case **machine1**'s IP address is `192.168.108.71`.
Using `grep -r '192.168.108.71'` you can see all the occurences of the **machine1 IP**.
Using ` sed -i 's/192.168.108.71/YOUR_MACHINE_1_IP/g' *` you can replace all of them with your own machine1 IP address.

At this point you should be able to start the network without any errors, using  `./network.sh start`.
If it works, stop the network with **Ctrl+C**.  Also execute `./network.sh clean` to remove the generated crypto material. 
If you get the following error, retry.
````shell
Error: error getting endorser client for channel: endorser client failed to connect to 192.168.108.71:7051: failed to create new connection: connection error: desc = "transport: error while dialing: dial tcp 192.168.108.71:7051: connect: connection refused"
````



Now we have to include **machine2**'s IP address inside the config files.
In my case **machine2**'s IP address is `192.168.108.74`.
Using `grep -r '192.168.108.74' .`, you can see the two config files that needs editing. 
Using `sed -i 's/192.168.108.74/YOUR_MACHINE_2_IP/g' *` you can replace them with your own machine2 IP address.

Adding more orgs on different hosts, requires editing those two files (crypto-config.yaml and configtx.yaml).

### Second machine setup

Navigate to the `distributed-machine-2` directory.
In my case **machine2**'s IP address is `192.168.108.74`.
Using `grep -r '192.168.108.74'` you can see all the occurences of the **machine2 IP**.
Using `sed -i 's/192.168.108.74/YOUR_MACHINE_2_IP/g' *` you can replace all of them with your own machine2 IP address.

Also edit the `copy.sh` and `get_chaincode.sh` scripts to match the user and the IP address of machine1.
 


### Starting the network

Just like test-network-nano-bash, starting the network can be done either by running each component separately, or with a single command.

#### Running each component separately
The flow that needs to be followed is outlined below:

 - Generate crypto material for all orgs and orderers on machine1. `./generate_artifacts.sh`
 - Start orderers on machine1 (on separate terminals) `./orderer1.sh` `./orderer2.sh` `./orderer3.sh`
 - Start peers on machine1 (on separate terminals) `./peer1.sh` `./peer3.sh`
 - Copy the crypto material on machine2 `./copy.sh`
 - Start peer on machine2 `./peer5.sh`
 - Join the orderers on machine1 `./join_orderers.sh`
 - Join the channel with each peer. On machine1:
     -  `source peer1admin.sh && ./join_channel.sh`
     - `source peer3admin.sh && ./join_channel.sh`
- On machine2:
    - `source peer5admin.sh && ./join_channel.sh`


#### Running the network with a single command

On machine1:

 - `./network.sh clean` to remove old data
 - `./network.sh start` to start the network. Wait for it to finish initializing

On machine2:
 - `./peer5.sh` to start the peer
  - `source peer5admin.sh && ./join_channel.sh` to join the network


# Instructions for deploying and running the basic asset transfer sample chaincode

The chaincode in the Test-network-nano-bash network  can be deployed either using chaincode container or chaincode as a service.

I have only deployed the chaincode using the container, but chaincode as a service should also work.


## Using a chaincode container

Package and install the chaincode on peer1:

```shell
peer lifecycle chaincode package basic.tar.gz --path ../asset-transfer-basic/chaincode-go --lang golang --label basic_1

peer lifecycle chaincode install basic.tar.gz
```

The chaincode install may take a minute since the `fabric-ccenv` chaincode builder docker image will be downloaded if not already available on your machine.

Copy the returned chaincode package ID into a `CHAINCODE_ID` environment variable for use in subsequent commands, or better yet use the peer `calculatepackageid` command to set the environment variable:

```shell
export CHAINCODE_ID=$(peer lifecycle chaincode calculatepackageid basic.tar.gz) && echo $CHAINCODE_ID
```



## Activate the chaincode

Using the peer1 admin, approve and commit the chaincode (only a single approver is required based on the lifecycle endorsement policy of any organization):

```shell
peer lifecycle chaincode approveformyorg -o 192.168.108.71:6050 --channelID mychannel --name basic --version 1 --package-id $CHAINCODE_ID --sequence 1 --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

peer lifecycle chaincode commit -o 192.168.108.71:6050 --channelID mychannel --name basic --version 1 --sequence 1 --tls --cafile "${PWD}"/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
```
**Note:** replace the IP with your **machine1** IP address.
**Note:** after following the instructions above, the chaincode will only be installed on peer1 and will only be available in the peer1admin shell.
Rerun the `peer lifecycle chaincode install` command in other peer admin shells to install it on the corresponding peer. 
You will also need to rerun the `peer lifecycle chaincode approveformyorg` command to use the chaincode on peers in another organization, e.g. using the peer3admin shell.

Peers on **different machines** need to get the packaged chaincode using `get_chaincode.sh` script, before installing and approving.



## Interact with the chaincode

Invoke the chaincode to create an asset (only a single endorser is required based on the default endorsement policy of any organization).
Then query the asset, update it, and query again to see the resulting asset changes on the ledger. Note that you need to wait a bit for invoke transactions to complete.

```shell
peer chaincode invoke -o 192.168.108.71:6050 -C mychannel -n basic -c '{"Args":["CreateAsset","1","blue","35","tom","1000"]}' --waitForEvent --tls --cafile "${PWD}"/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","1"]}'

peer chaincode invoke -o 192.168.108.71:6050 -C mychannel -n basic -c '{"Args":["UpdateAsset","1","blue","35","jerry","1000"]}' --waitForEvent --tls --cafile "${PWD}"/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","1"]}'
```



**Congratulations**, you have deployed a minimal Fabric network! Inspect the scripts if you would like to see the minimal set of commands that were required to deploy the network.

# Stopping the network

If you started the Fabric components individually, utilize `Ctrl-C` in the orderer and peer terminal windows to kill the orderer and peer processes. You can run the scripts again to restart the components with their existing data, or run `./generate_artifacts` again to clean up the existing artifacts and data if you would like to restart with a clean environment.

If you used the `network.sh` script, utilize `Ctrl-C` to kill the orderer and peer processes. You can restart the network with the existing data, or run `./network.sh clean` to remove old data before restarting.

