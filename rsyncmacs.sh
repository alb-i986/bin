#!/bin/bash

IMAC=192.168.1.130
MACBOOK=192.168.1.64

usage() {
  echo "Usage: $0 imac|macbook (the machine specified is the target)"
}


if [ "$#" -ne "1" ]; then
  usage
  exit 0
fi

if [ "$1" == "imac" ]; then
  TARGET=$IMAC
elif [ "$1" == "macbook" ]; then
  TARGET=$MACBOOK
else
  usage
  exit 0
fi

set -x

if [ "$1" == "imac" ]; then
  rsync -avz --delete --progress --exclude='.*' --exclude=torrent $MACBOOK:Downloads ~
  rsync -avz --delete --progress --exclude='.*' --exclude=cucina/gz $MACBOOK:'Documents etc' ~
  rsync -avz --delete --progress $MACBOOK:bin ~
  rsync -avz --delete --progress --exclude=target $MACBOOK:workspace ~
  rsync -avz --delete --progress --exclude=wrapper $MACBOOK:.m2 ~

elif [ "$1" == "macbook" ]; then
  rsync -avz --delete --progress --exclude='.*' --exclude=torrent Downloads $MACBOOK:
  rsync -avz --delete --progress --exclude='.*' --exclude=cucina/gz Documents etc $MACBOOK:
  rsync -avz --delete --progress bin $MACBOOK:
  rsync -avz --delete --progress --exclude=target workspace $MACBOOK:
  rsync -avz --delete --progress --exclude=wrapper .m2 $MACBOOK:

fi



#TMPDIR=$(mktemp -d -t rsyncmac)
#scp $TARGET:/etc/hosts $TMPDIR
#
#echo
#echo
#echo "diff hosts:"
#diff -u /etc/hosts $TMPDIR/hosts

#scp .bash_aliases .bash_functions .bashrc .mybashrc $TARGET:tmp/rsync

#rm -rf $TMPDIR
