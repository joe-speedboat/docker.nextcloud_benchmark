#!/bin/bash

#########################################################################################
# DESC: docker entry point
#########################################################################################
# Copyright (c) Chris Ruettimann <chris@bitbull.ch>

# This software is licensed to you under the GNU General Public License.
# There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/gpl.txt

# HOW IT WORKS:
# 1) parse ENV
# 2) create benchmark vars
# 3) loop the benchmark
#
# INSTALL:
#   https://github.com/joe-speedboat/docker.nextcloud_benchmark

set -o pipefail

set +e

# Script trace mode
if [ "${DEBUG_MODE,,}" == "true" ]; then
    set -o xtrace
fi

NC_BENCH_CONF=/tmp/nc_benchmark.conf
NC_BENCH_SCRIPT=/usr/bin/nc_benchmark.sh

echo "
CLOUD=\"${CLOUD:=ony_idiots_try_to_do_this}\"
USR=\"${USR:=admin}\"
PW=\"${PW:=passowrd_is_mandatory___idiot}\"
TEST_BLOCK_SIZE_MB=\"${TEST_BLOCK_SIZE_MB:=$(shuf -i 10-4096 -n1)}\"
TEST_FILES_COUNT=\"${TEST_FILES_COUNT:=$(shuf -i 10-200 -n1)}\"
BENCH_DIR=\"$(curl ifconfig.me | tr '.' '_')_$HOSTNAME\"
SPEED_LIMIT_UP=\"${SPEED_LIMIT_UP:=$(shuf -i 1-200 -n1)M}\"
SPEED_LIMIT_DOWN=\"${SPEED_LIMIT_DOWN:=$(shuf -i 20-200 -n1)M}\"
LOCAL_DIR=/tmp
" > $NC_BENCH_CONF



while true
do
   echo "####################### STARTING ########################"
   cat $NC_BENCH_CONF
   echo "#########################################################"
   echo "INFO: Testing connectivity"
   curl -k -s -L https://$CLOUD 2>&1 >/dev/null 
   if [ $? -eq 0 ]
   then
     $NC_BENCH_SCRIPT $NC_BENCH_CONF || true
     # cat $LOCAL_DIR/$BENCH_DIR.txt || true
   else
     echo "ERROR: I CANT REACH THIS NEXTCLOUD, SO I WAIT"
   fi   
   SLEEP=$(shuf -i 5-15 -n1)
   echo SLEEPING $SLEEP seconds
   sleep $SLEEP
done

