# Raspberry Pi TP-Link Omada Controller
[![Build Status](https://travis-ci.org/frbncis/docker-arm32v7-omada.svg?branch=master)](https://travis-ci.org/frbncis/docker-arm32v7-omada)
[![Docker Pulls](https://img.shields.io/docker/pulls/frnby/omada-eap-controller.svg)](https://hub.docker.com/r/frnby/omada-eap-controller)
[![Last Commit](https://img.shields.io/github/last-commit/frbncis/docker-arm32v7-omada.svg)](https://github.com/frbncis/docker-arm32v7-omada)

This repo contains the Dockerfile for running the TP Link Omada Controller as a container on an Raspberry Pi 3

This is currently a WIP. Use at your own risk.

## Quick Start

```
docker run -d --net=host --restart=always frnby/omada-eap-controller
```

Then browse to to it on http://device_ip:8088 or https://device_ip:8043

Notes:
* Startup takes awhile... Sometimes up to 10 minutes.
* You can volume mount the `/opt/tplink/EAPController/data` and the `/opt/tplink/EAPController/logs` to the host if you want to persist it.
* `docker stop` doesn't gracefully shutdown the embedded MongoDB instance.
* Sometimes it fails trying to startup (especially if you don't have the `--restart=always` flag set). Not sure why, but eventually it will run.

## Building 
The `build.sh` script will take care of setting up the x86/x64 environment for building an ARM image.

```
./build.sh . -t frnby/omada-controller-test
```
