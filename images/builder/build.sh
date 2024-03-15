#!/bin/sh

set -eu

SRC_PATH=/src

uid=$(stat --format="%u" "${SRC_PATH}")
gid=$(stat --format="%g" "${SRC_PATH}")
echo "builder:x:${uid}:${gid}::${SRC_PATH}:/bin/bash" >>/etc/passwd
echo "builder:*:::::::" >>/etc/shadow
echo "builder	ALL=(ALL)	NOPASSWD: ALL" >>/etc/sudoers

su builder -c "PATH=${PATH} make -C ${SRC_PATH} BUILD_IN_CONTAINER=false $*"
