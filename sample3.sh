#!/bin/bash

# Start values
app_list=("kubectl=1.24.3" "kubeadm=1.24.3" "kubectl=1.24.3" )
var_kube_version="1.24.3"
var_kube_list=("kubectl" "kubelet" "kubeadm")
var_docker_version="999"
var_docker_list=("docker")
var_containerd_version="999"
var_containerd_list="containerd"
var_test=false
arr_install_apps=()
var_options=$@

# Functions

function test_kubernetes(){
  for value in "${var_kube_list[@]}"
  do
    echo "$value=$var_kube_version"
  done
  for a in ${var_kube_list[@]}
  do
    # echo "Looking at $a"
    dpkg -s <package> | grep Version
    var_temp=$(which kubectl)
    var_err_code=$?
    if [[ $var_err_code -eq 0 ]]
      then
        echo "OK   = $a"
      else
        echo "$a NOT installed"
        arr_install_apps[${#arr_install_apps[@]}]="$a"
    fi
  done
  echo "The following has been added to the install que list"
  for value in "${arr_install_apps[@]}"
  do
    echo "* $value"
  done
}

# Parsing

# echo "** Sample script to parse arguments **"

while getopts 'tic:k:h' opt; do
  case "$opt" in

    i)
      # echo "Processing option $opt"
      ;;

    t)
      # echo "Processing option $opt and setting: var_test=true"
      var_test=true
      ;;

    c)
      arg="$OPTARG"
      # echo "Processing option 'c' with '${OPTARG}' argument"
      ;;

    k)
      arg="$OPTARG"
      # echo "Processing option 'c' with '${OPTARG}' argument"
      var_kube_version=$arg
      #var_kube_list=("kubectl=$var_kube_version" "kubelet=$var_kube_version" "kubeadm=$var_kube_version")
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-a] [-b] [-c arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Starting script according to options

printf "** Kubernetes script for Linux (Debian/Ubuntu) **

This script is designed to make installation of Kubernetes easy on a Linux 
(Debian/Ubuntu) system. The script assumes that you want to use $var_kube_version 
of kubelet, kubectl, and kubeadm.

And that you will use the following repositories, if non of your existing
repositories contain the correct versions:
...
For container runtime it is assumed that you will used containerd version $var_containerd_version,
and that you will use docker version $var_docker_version.
...
"

echo "You passed these options: $var_options"

read -p "Do you wish to continue [y/n]? "  yn


case $yn in 
	y | yes | Yes ) echo ok, we will proceed;;
	n | no | No) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

if [[ var_test ]]; then test_kubernetes; fi