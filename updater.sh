#!/bin/bash

cd /home/ubuntu/map_muncher

git pull
ruby convert_to_json.rb
cp ./map_data.json /home/ubuntu/coyotl/source/public/data/
