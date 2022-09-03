#!/bin/bash

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

function test_a_equals_or_bigger_than_b () {
  var_a=$1
  var_b=$2

  var_a="$(echo $var_a | sed "s/[^0-9]/./g")"
  echo $var_a 

  var_b="$(echo $var_b | sed "s/[^0-9]/./g")"
  echo $var_b 

  var_a_fields=$(echo $var_a | awk -F . "{ print NF }")    
  echo $var_a_fields
  var_fields=$var_a_fields

  var_b_fields=$(echo $var_a | awk -F . "{ print NF }")    
  echo $var_b_fields

  if [[ $var_b_fields -gt $var_a_fields ]]; then var_fields=$var_b_fields; fi

#  echo $var_a | awk '{for(i=1; i<=NF; i++) { print $0,i}}'

  for i in $(seq 1 1 $var_fields)
  do
    echo "$i...$var_a"
    k=$(echo $var_a | awk -F . -v c1=$i '{ printf $c1 }')
    echo $k
  done

  # var_temp=$(awk -F. '{ print $var_a $a }')
  # echo $var_temp
}

# testvercomp 1.23.0 1.24.0 '<' 
# echo $? " (error code)"
# testvercomp 1.23.0 1.24.0 '>' 
# echo $? " (error code)"

test_a_equals_or_bigger_than_b 1.23.0 1.24.0

