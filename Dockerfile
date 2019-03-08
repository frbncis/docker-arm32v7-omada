FROM arm32v7/openjdk:8-jre-slim
HEALTHCHECK CMD wget --quiet --tries=1 --no-check-certificate http://127.0.0.1:8088 || exit 1

ARG OMADA_FILENAME=Omada_Controller_v3.0.5_linux_x64
ARG MONGO_ARM_FILENAME=core_mongodb_3_0_14

COPY bin/qemu-arm-static /usr/bin

WORKDIR /tmp

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    wget && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_armhf.deb && \
  dpkg -i libssl1.0.0_1.0.1t-1+deb8u10_armhf.deb

RUN wget -q https://static.tp-link.com/2018/201811/20181108/$OMADA_FILENAME.tar.gz.zip && \
  unzip $OMADA_FILENAME.tar.gz.zip

RUN tar -xvf $OMADA_FILENAME.tar.gz

RUN wget -q https://andyfelong.com/downloads/$MONGO_ARM_FILENAME.tar.gz && \
  tar -xvf $MONGO_ARM_FILENAME.tar.gz && \
  cp mongod /tmp/$OMADA_FILENAME/bin/

ARG INSTALL_DIR=/opt/tplink/EAPController

WORKDIR /tmp/$OMADA_FILENAME
RUN mkdir -p $INSTALL_DIR && \
  for name in bin data properties webapps keystore lib; do cp $name $INSTALL_DIR -r;  done && \
  ln -s /docker-java-home/jre $INSTALL_DIR/jre && \
  mkdir $INSTALL_DIR/logs && \
  rm -rf /tmp/* && \
  rm /usr/bin/qemu-arm-static

EXPOSE 8043/tcp 8088/tcp 27001/udp 27002/tcp 29810/udp 29811/tcp 29812/tcp 29813/tcp

WORKDIR $INSTALL_DIR
CMD java -server -Xms128m -Xmx1024m -XX:MaxHeapFreeRatio=60 -XX:MinHeapFreeRatio=30 -XX:+HeapDumpOnOutOfMemoryError -cp /usr/share/java/commons-daemon.jar:/opt/tplink/EAPController/lib/* -Deap.home=/opt/tplink/EAPController com.tp_link.eap.start.EapLinuxMain
