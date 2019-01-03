FROM arm32v7/openjdk:8-jre
HEALTHCHECK CMD curl --fail http://localhost:8043/ || exit 1

ARG OMADA_FILENAME=Omada_Controller_v3.0.5_linux_x64
ARG MONGO_ARM_FILENAME=core_mongodb_3_0_14

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    curl \
    jsvc \
    net-tools \
    procps

RUN echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free" | tee "/etc/apt/sources.list.d/raspbian-jessie.list" && \
  wget -O- https://archive.raspbian.org/raspbian.public.key | apt-key add - && \
#  apt-key adv --keyserver --no-tty hkp://keyserver.ubuntu.com:80 --recv 9165938D90FDDD2E && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libssl1.0.0 && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://static.tp-link.com/2018/201811/20181108/$OMADA_FILENAME.tar.gz.zip && \
  unzip $OMADA_FILENAME.tar.gz.zip

RUN tar -xvf $OMADA_FILENAME.tar.gz

RUN wget https://andyfelong.com/downloads/$MONGO_ARM_FILENAME.tar.gz && \
  tar -xvf $MONGO_ARM_FILENAME.tar.gz && \
  cp mongod /tmp/$OMADA_FILENAME/bin/

ARG INSTALL_DIR=/opt/tplink/EAPController

WORKDIR /tmp/$OMADA_FILENAME
RUN mkdir -p $INSTALL_DIR && \
  for name in bin data properties webapps keystore lib; do cp $name $INSTALL_DIR -r;  done && \
  ln -s /docker-java-home/jre $INSTALL_DIR/jre && \
  mkdir $INSTALL_DIR/logs && \
  rm -rf /tmp/*

EXPOSE 8043
WORKDIR $INSTALL_DIR
#CMD ["java","-client","-Xms128m","-Xmx1024m","-XX:MaxHeapFreeRatio=60","-XX:MinHeapFreeRatio=30", "-XX:+UseSerialGC", "-XX:+HeapDumpOnOutOfMemoryError","-Deap.home=/opt/tplink/EAPController", "-cp /opt/tplink/EAPController/lib/com.tp-link.eap.start-0.0.1-SHAPSHOT.jar:/opt/tplink/EAPController/lib/*:/opt/tplink/EAPController/external-lib/*", "com.tp_link.eap.start.EapLinuxMain"]
CMD java -server -Xms128m -Xmx1024m -XX:MaxHeapFreeRatio=60 -XX:MinHeapFreeRatio=30 -XX:+HeapDumpOnOutOfMemoryError -cp /usr/share/java/commons-daemon.jar:/opt/tplink/EAPController/lib/* -Deap.home=/opt/tplink/EAPController com.tp_link.eap.start.EapLinuxMain
#CMD ["java", "-server", "-Xms128m", "-Xmx1024m", "-XX:MaxHeapFreeRatio=60", "-XX:MinHeapFreeRatio=30", "-XX:+HeapDumpOnOutOfMemoryError", "-cp /usr/share/java/commons-daemon.jar:/opt/tplink/EAPController/lib/*", "-Deap.home=/opt/tplink/EAPController", "com.tp_link.eap.start.EapLinuxMain"]
