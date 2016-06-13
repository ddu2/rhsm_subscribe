#!/bin/bash
#
#
#  date:  2016-06-13

username='rhn-support-ddu'
#password='xxxx'

version=`uname -r | awk -F 'el' '{print $2}' | awk -F '.' '{print $1}'`

if [ `subscription-manager facts --list | grep is_guest | awk -F ': ' '{print $2}'` == 'True' ]; then
    SystemType='Virtual'
else
    SystemType='Physical'
fi

subscription-manager clean

subscription-manager register --username $username

pool_id=`subscription-manager list --all --available|egrep 'Subscription Name|Pool ID|System Type'|grep -A2 'Employee SKU'|grep -B1 $SystemType|grep Pool|sed 's/Pool ID:           //g'`
subscription-manager attach --pool $pool_id

channel_list=`subscription-manager repos|egrep 'Repo ID|Enabled'|grep -B1 'Enabled:   1'|grep Repo|sed 's/Repo ID:   /--disable /g'`
subscription-manager repos $channel_list

subscription-manager repos \
    --enable rhel-$version-server-optional-rpms \
    --enable rhel-$version-server-supplementary-rpms \
    --enable rhel-$version-server-rpms
#    --enable rhel-ha-for-rhel-$version-server-rpms \
#    --enable rhel-$version-server-eus-rpms \
