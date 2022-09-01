#!/bin/bash

# Start values
var_test=false
arr_install_apps=()

# Functions

function test_kubernetes(){
  arr_apps=("kubectl" "kubeadm" "kubelet")
  for a in ${arr_apps[@]}
  do
    # echo "Looking at $a"
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

echo "** Sample script to parse arguments **"

while getopts 'tic:h' opt; do
  case "$opt" in

    i)
      echo "Processing option $opt"
      ;;

    t)
      echo "Processing option $opt and setting: var_test=true"
      var_test=true
      ;;

    c)
      arg="$OPTARG"
      echo "Processing option 'c' with '${OPTARG}' argument"
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-a] [-b] [-c arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Starting script according to options

if [[ var_test ]]; then test_kubernetes; fi