#!/bin/bash

cd /home/ubuntu/map_muncher

git remote update
if !(git status -uno | grep -q "Your branch is up to date with 'origin/master'.")
then
    git pull
    ./convert_to_json.rb
fi
cp ./map_data.json /home/ubuntu/coyotl/source/public/data/

cd -
