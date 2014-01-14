#!/bin/sh

echo -e "\n\033[1mUpdate Virt2real SDK components\033[0m"

echo -e "\n\033[1;34mUpdate SDK scripts\033[0m"
git pull

DIRS="adminka dvsdk fs kernel uboot"
for dir in $DIRS;
do
	echo -e "\n\033[1;34mUpdate $dir\033[0m"
	cd $dir && git pull
	cd ..
done

echo -e "\n\033[1mupdate done\033[0m"
