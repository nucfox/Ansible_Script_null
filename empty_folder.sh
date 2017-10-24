#! /bin/bash
###create .ingore dummy file for copying to empty folder
touch .ingore
###use find the files and folders list 
for i in `find . -path ./.git -prune -o -type d` ; do
###check is folder and exist? 
  if [ -e $i ] ; then
####yes, check is empty folder
    if [ ! "`ls -A $i`" ] ; then
      echo $i is empty folder
#### copy dummy file to this empty folder
      cp .ingore $i
    fi
  fi
done
