#!/bin/bash
source_node=$1
destination_node=$2


if [ "$source_node" == "node1" ] || [ "$source_node" = "node2" ] || [ "$source_node" = "node3" ] || [ "$source_node" = "node4" ] || [ "$source_node" = "router" ]; then
    #echo "it enters the first if" 
    if [ "$destination_node" = "node1" ] || [ "$destination_node" = "node2" ] || [ "$destination_node" = "node3" ] || [ "$destination_node" = "node4" ] || [ "$destination_node" = "router" ]; then
    #echo "ops1"
    declare -A nodes=(
            ["node1"]="172.0.0.2"
            ["node2"]="172.0.0.3"
            ["node3"]="10.10.0.2"
            ["node4"]="10.10.0.3"
        )
    #echo "it enter the second if"
    declare -A router_ips=(
            ["172.0.0.2"]="172.0.0.1"
            ["172.0.0.3"]="172.0.0.1"
            ["10.10.0.2"]="10.10.0.1"
            ["10.10.0.3"]="10.10.0.1"
        )
    #echo "it enter the third if"
    source_ip=${nodes[$source_node]}
        if [ "$destination_node" = "router" ]; then
            destination_ip=${router_ips[$source_ip]}
        else
            destination_ip=${nodes[$destination_node]}
        fi
        ip netns exec $source_node ping $destination_ip -c4
        #echo "it enter the last if"
    else
        echo "no destination node with the given name exist"
    fi
else
    echo "no source node with the given name exist"
fi    

    
        
        
        