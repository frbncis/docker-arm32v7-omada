# Raspberry Pi TP-Link Omada Controller
This repo contains the Dockerfile for running the TP Link Omada Controller as a container on an Raspberry Pi 3

This is currently a WIP. Use at your own risk.

## Quick Start
-----------

```
docker run -d --net=host --restart=always frnby/omada-eap-controller
```

Notes:
* You can volume mount the /opt/tplink/EAPcontroller/data and the /opt/tplink/EAPcontroller/logs to the host if you want to persist it.
* `docker stop` doesn't gracefully shutdown the embedded MongoDB instance.
* Sometimes it fails trying to startup (especially if you don't have the `--restart=always` flag set). Not sure why, but eventually it will run.
