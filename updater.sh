#!/bin/bash

cd /home/ubuntu/map_muncher

git remote update
if !(git status -uno | grep -q "Your branch is up to date with 'origin/master'.")
then
    git pull
    ./convert_to_json.rb
    /home/ubuntu/log_alert/updater.sh
fi
mkdir -p /home/ubuntu/coyotl/source/public/data/
cp --preserve ./map_data.json /home/ubuntu/coyotl/source/public/data/

cd -
