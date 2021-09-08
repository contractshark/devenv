#!/bin/sh
spctl kext-consent disable
sudo kextcache --clear-staging
sudo kextcache -i /
echo "under System Security allow the System software from ${developer_name} "
sleep 10
