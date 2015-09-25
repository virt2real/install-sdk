#!/bin/sh

if [ "$#" -lt 1 ]
then
  echo "Usage: `basename $0` IMG_PATH"
  exit 1
fi

IMGPATH=$1

if [ `sudo losetup /dev/loop0 2>/dev/null| wc -l` -eq 0 ] ;
	then
		echo -e "\033[1mImage file not mounted to /dev/loop0\033[0m"
		sudo losetup /dev/loop0 ${IMGPATH}
fi

OFFSETS=`sudo sfdisk -uS -l /dev/loop0 2>/dev/null | awk '\
    $1 ~ /.*\loop0p1/ { print $3 } \
    $1 ~ /.*\loop0p1/ { print $4 } \
    $1 ~ /.*\loop0p2/ { print $2 } \
'`

# echo $OFFSETS

set ${OFFSETS}
OFFSET_BOOT=${1}
OFFSET_BOOT_END=${2}
OFFSET_ROOT=${3}

# echo Offsets: $OFFSET_BOOT $OFFSET_BOOT_END $OFFSET_ROOT

sudo losetup /dev/loop1 ${IMGPATH} -o $((512*${OFFSET_BOOT})) --sizelimit $((512*(${OFFSET_BOOT_END}-${OFFSET_BOOT})))
sudo losetup /dev/loop2 ${IMGPATH} -o $((512*${OFFSET_ROOT}))

