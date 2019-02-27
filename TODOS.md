Todos:
======

* Cleanly shutdown the MongoDB process. 

    - The original installation uses control.sh and jsvc that uses a shutdown hook to cleanly shutdown MongoDB, but the current Docker approach outright kill -9 the java process, so no hooks get invoked.

    - Idea: Entrypoint script runs the java process and monitors for kill signals. on trapping a kill signal, the script will cleanly shutdown the mongo process using kill -2 or another method outlined here https://www.ctl.io/developers/blog/post/gracefully-stopping-docker-containers/. 

* Separate out the MongoDB instance 
    - Modify the connection string
    - Check the PID file that the Java process creates, see if the Java process has dependency on that.:

```bash
"/opt/tplink/EAPController/bin/mongod" --port 27217 --dbpath "/opt/tplink/EAPController/data/db" -pidfilepath "/opt/tplink/EAPController/data/mongo.pid" --logappend --logpath "/opt/tplink/EAPController/logs/mongod.log" --nohttpinterface --bind_ip 127.0.0.1 --journal
"/opt/tplink/EAPController/bin/mongod" --repair --dbpath "/opt/tplink/EAPController/data/db" --logappend --logpath "/opt/tplink/EAPController/logs/mongod.log" --journal
```

* Combine the stdout of the Java process with the log file in `/opt/tplink/EAPController/logs/server.log` to the overall container's stdout for monitoring.