#!/bin/bash

cd /home/ubuntu/map_muncher

if !(git diff --quiet)
then
    git pull
    ./convert_to_json.rb
fi
cp ./map_data.json /home/ubuntu/coyotl/source/public/data/

cd -
