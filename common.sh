#!/bin/bash
#
# utils functions
#


print_err() {
  msg=$1
  {
    echo "    err: $msg"
  } >&2
  return 0
}

err_exit() {
  msg=$1
  print_err "$msg"
  exit 1
}


ask_var() {
  var_name=$1
  default_val=$2
  msg=$3

  # args $var_name and $default_val are required
  [[ $# -ge 2 && $# -le 3 ]] || return 1

  if [ -z "$msg" ] ; then
    msg="enter a value for variable $var_name:"
  fi

  read -p "$msg " $var_name
  if [ -z "${!var_name}" ] ; then
    read $var_name <<EOF
      $default_val
EOF
  fi
  return 0
}

ask_var_nodefault() {
  var_name=$1
  msg=$2

  [[ $# -ge 1 && $# -le 2 ]] || return 1

  if [ -z "$msg" ] ; then
    msg="enter a value for variable $var_name:"
  fi

  # loop until we have a non empty answer from the user
  while [[ -z "${!var_name}" ]] ; do
    read -p "$msg " $var_name
  done
  return 0
}

ask_confirm() {
  msg=$1

  echo
  echo $msg
  read -p "are you sure? " answer
  if [[ -z "$answer" || "$answer" =~ ^[yY]$ ]] ; then
    return 0
  else
    return 1
  fi
}

exists_cmd() {
  [[ $# -ge 1 ]] || return 1

  cmd=$1
  which $cmd >/dev/null
}

filename() {
  if [ $# -ne 1 ] ; then
    return 1
  fi
  path=$1
  expr "$path" : '.*\/\(.*\)'
  return 0
}

strip_ext() {
  if [ $# -ne 1 ] ; then
    return 1
  fi
  filename=$1
  ext=$( expr "$filename" : '.*\(\..*\)' )
  echo ${filename/%$ext/}
  return 0
}
