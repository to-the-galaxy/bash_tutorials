#!/bin/bash

# Start values
app_list=("kubectl=1.24.3" "kubeadm=1.24.3" "kubectl=1.24.3" )
var_kube_version="1.24.3"
var_kube_list=("kubectl" "kubelet" "kubeadm")
var_docker_version="999"
var_docker_list=("docker-ce" "docker-ce-cli")
var_containerd_version="999"
var_containerd_list="containerd"
var_test=false
arr_install_apps=()
var_options=$@

# Functions

vercomp(){
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
        echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
    else
        echo "Pass: '$1 $op $2'"
    fi
}

function test_kubernetes(){
  for a in ${var_kube_list[@]}
  do
    # echo "Looking at $a"
    var_temp=$(dpkg -s $a | grep Version | awk '{ printf $2 }' )
    # var_temp=$(which kubectl)
    var_err_code=$?
    if [[ $var_err_code -eq 0 ]]
      then
        echo "[  OK  ] = $a version $var_temp"
      else
        echo "$a NOT installed"
        arr_install_apps[${#arr_install_apps[@]}]="$a"
    fi
  done
#   echo "The following has been added to the install que list"
#   for value in "${arr_install_apps[@]}"
#   do
#     echo "* $value"
#   done
}


function test_docker(){

  var_temp=$(docker version --format '{{.Client.Version}}')
  var_err_code=$?
  if [[ $var_err_code -eq 0 ]]
    then
      echo "[  OK  ] = docker client version $var_temp"
    else
      echo "$a NOT installed"
  fi

  var_temp=$(docker version --format '{{.Server.Version}}')
  var_err_code=$?
  if [[ $var_err_code -eq 0 ]]
    then
      echo "[  OK  ] = docker server version $var_temp"
    else
      echo "$a NOT installed"
  fi

  # for a in "${var_docker_list[@]}"
  #   var_temp=$(dpkg -s $a | grep Version | awk '{ printf $2 }' )
  #   var_err_code=$?
  #   if [[ $var_err_code -eq 0 ]]
  #     then
  #       echo "OK   = $a version $var_temp"
  #     else
  #       echo "$a NOT installed"
  #       arr_install_apps[${#arr_install_apps[@]}]="$a"
  #   fi
  # done
  # echo "The following has been added to the install que list"
  # for value in "${arr_install_apps[@]}"
  # do
  #   echo "* $value"
  # done
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
if [[ var_test ]]; then test_docker; fi

# while read -r test
# do
#     testvercomp $test
# done

testvercomp 1.23.0 1.24.0 '<' 
echo $? " (error code)"
testvercomp 1.23.0 1.24.0 '>' 
echo $? " (error code)"



