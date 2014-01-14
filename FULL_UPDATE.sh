#!/bin/sh
#
echo -e "\033[1;34mUpdate SDK scripts\033[0m"
git pull
#
echo -e "\033[1;34mUpdate SDK components\033[0m"
#
DIRS=`ls -d */` # or `cat .gitignore`
#
for dir in $DIRS;
do
	echo -e "\033[1;34mUpdate $dir\033[0m"
	cd $dir && git pull
	cd ..
done
