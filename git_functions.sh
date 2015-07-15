#!/bin/bash
# functions about git
# beware: by importing this file you get git_restore_state trapped

trap "git_restore_state ; exit" SIGHUP SIGINT SIGTERM

git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_save_state() {
  ORIGINAL_BRANCH=$( git_current_branch )
  stash_output=`git stash --include-untracked`
  # TODO improve "did an err occur?" logic -- should not be based on the exact string
  if [ "$stash_output" = "No local changes to save" ] ; then
    STASHED=0
  else
    STASHED=1
  fi
}

git_restore_state() {
  ret=0 # assume success
  echo
  if [ -n "$ORIGINAL_BRANCH" ] ; then
    git co "$ORIGINAL_BRANCH" || {
      echo "ERR: Failed to restore the original state of the working dir"
      return 1
    }
  fi
  if [ "$STASHED" = 1 ] ; then
    git stash pop
    ret=$?
  fi
  STASHED=0
  return $ret
}

