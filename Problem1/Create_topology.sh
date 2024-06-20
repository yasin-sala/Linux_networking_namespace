#!/bin/bash

# Creating hosts 
ip netns add node1
ip netns add node2
ip netns add node3
ip netns add node4

# Create router
ip netns add router

# Create bridges and set them up
ip link add br1 type bridge
ip link set br1 up
ip link add br2 type bridge
ip link set br2 up

# Create links
ip link add node1-br1 type veth peer name br1-node1 
ip link add node2-br1 type veth peer name br1-node2
ip link add node3-br2 type veth peer name br2-node3
ip link add node4-br2 type veth peer name br2-node4

ip link add br1-eth1 type veth peer name eth1-br1
ip link add br2-eth2 type veth peer name eth2-br2

# Attach links to nodes
ip link set node1-br1 netns node1
ip link set node2-br1 netns node2
ip link set node3-br2 netns node3
ip link set node4-br2 netns node4

# Attach links to router
ip link set eth1-br1 netns router
ip link set eth2-br2 netns router

# Attach links to bridge1
ip link set br1-node1 master br1
ip link set br1-node2 master br1
ip link set br1-eth1 master br1

# Attach links to bridge2
ip link set br2-node3 master br2
ip link set br2-node4 master br2
ip link set br2-eth2 master br2




# Setting links attached to bridge1 up
ip link set br1-node1 up
ip link set br1-node2 up
ip link set br1-eth1 up

# Setting links attached to bridge2 up
ip link set br2-node3 up
ip link set br2-node4 up
ip link set br2-eth2 up

# Assign ip to namespaces
ip netns exec node1 ip address add 172.0.0.2/24 dev node1-br1
ip netns exec node2 ip address add 172.0.0.3/24 dev node2-br1
ip netns exec node3 ip address add 10.10.0.2/24 dev node3-br2
ip netns exec node4 ip address add 10.10.0.3/24 dev node4-br2

ip netns exec router ip address add 172.0.0.1/24 dev eth1-br1
ip netns exec router ip address add 10.10.0.1/24 dev eth2-br2

# 

ip netns exec node1 ip link set dev lo up
ip netns exec node1 ip link set dev node1-br1 up

ip netns exec node2 ip link set dev lo up
ip netns exec node2 ip link set dev node2-br1 up

ip netns exec node3 ip link set dev lo up
ip netns exec node3 ip link set dev node3-br2 up

ip netns exec node4 ip link set dev lo up
ip netns exec node4 ip link set dev node4-br2 up

ip netns exec router ip link set dev lo up
ip netns exec router ip link set dev eth1-br1 up
ip netns exec router ip link set dev eth2-br2 up

ip netns exec router sysctl net.ipv4.ip_forward=1

#
ip netns exec node1 route add default via 172.0.0.1
ip netns exec node2 route add default via 172.0.0.1
ip netns exec node3 route add default via 10.10.0.1
ip netns exec node4 route add default via 10.10.0.1







