#!/bin/bash

cd /home/ubuntu/map_muncher

if !(git pull | grep "Already up to date.")
then
    ./convert_to_json.rb
fi
cp ./map_data.json /home/ubuntu/coyotl/source/public/data/

cd -
