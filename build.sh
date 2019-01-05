#!/bin/bash
if [ ! -f ./bin/qemu-arm-static ]; then
  echo "Downloading qemu..."
  mkdir -p ./bin
  curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static ./bin
  rm -rf qemu-*
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

docker build . $@
