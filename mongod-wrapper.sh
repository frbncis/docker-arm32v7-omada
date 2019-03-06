#!/bin/bash

# /opt/tplink/EAPController/bin/mongod-real "${@:1:$(($#-1))}"

# Start socat to forward port 27107 to the MongoDB container
# 

echo "99" > /opt/tplink/EAPController/data/mongo.pid

socat TCP-LISTEN:27017,fork,reuseaddr TCP:mongodb:27017

