
# This script was made inorder to get a list of nodes in a cluster that are utilized under a threshold
# we decide. the main goal was to show that there are some nodes that are not utilized 
# the script has two functions 
# 1. fuction that checks if a threshold is under the desired amount
# 2. function that checks if a list of strings contains at least one of the strings of system namespaces 
#    (so we know if there are any non-system namespaces on that node)
# and then the script it self that prints the list of unutilized nodes and the non-system namespaces active on them.   

#!/bin/bash




# # install aws cli
# # connect to cluster


# Function to check if CPU utilization is under a given threshold
# inputs  cpu_utilization,threshold
is_cpu_utilization_under_threshold() {
  local cpu_utilization=$1

  # Modify the threshold as per your requirement (10% in this case)
  local threshold=$2

  if (( cpu_utilization <= threshold )); then
    return 0 # CPU utilization is under 10%
  else
    return 1 # CPU utilization is 10% or higher
  fi
}

# Function that checks if an array of strings contains a string from a list of other strings
# In our case to check if a node has a ns on it that ois system related according to "system_namespaces"
# input an array of namespaces "non_system_namespaces"
check_system_namespaces() {
  system_namespaces=("kube-system" "default" "kube-public" "kube-node-lease")
  # resetting the non_system_namespaces array
  non_system_namespaces=()
  for ns in "$@"; do
    found=false
    for sys_ns in "${system_namespaces[@]}"; do
      if [ "$ns" == "$sys_ns" ]; then
        found=true
        break
      fi
    done

    if [ "$found" = false ]; then
      non_system_namespaces+=("$ns")
    fi
  done
  if [ ${#non_system_namespaces[@]} -gt 0 ]; then
    IFS=$'\n'
    printf "Non-system namespaces:\n"
    printf "%s\n" "${non_system_namespaces[*]}"
  else
    echo "All namespaces are system namespaces."
  fi
}

# threshold_percentage
threshold_percentage=0

# Get CPU utilization for nodes
node_cpu_utilization=$(kubectl top nodes | tail -n +2)

# set num of unutilized_nodes_count=0
unutilized_nodes_count=0
# Iterate through each node to check CPU utilization
while IFS= read -r line; do
  node_name=$(echo "$line" | awk '{print $1}')
  cpu_utilization=$(echo "$line" | awk '{print $3}' | sed 's/%//')

  if is_cpu_utilization_under_threshold "$cpu_utilization" "$threshold_percentage"; then
    echo "Node $node_name has CPU utilization under 10%: ${cpu_utilization}%"
    ((unutilized_nodes_count++))
    # Get alist of all namespaces on the node
    all_namespaces=$(kubectl get pods --all-namespaces -o wide | grep "$node_name" | awk '{print $1}')
    # resetting the array
    namespaces_array=() 
    # Convert the space-separated string to an array
    while IFS= read -r ns; do
        namespaces_array+=("$ns")
    done <<< "$all_namespaces"
    # Check which namespace afe not system related namespaces and print them
    check_system_namespaces "${namespaces_array[@]}"
  fi
done <<< "$node_cpu_utilization"

# Output the total number of unused nodes
echo "Total number of nodes with CPU utilization equal or under 0%: $unutilized_nodes_count"




