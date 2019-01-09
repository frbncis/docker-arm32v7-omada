FROM arm32v7/openjdk:8-jre
HEALTHCHECK CMD curl --fail http://127.0.0.1:8088 || exit 1

ARG OMADA_FILENAME=Omada_Controller_v3.0.5_linux_x64
ARG MONGO_ARM_FILENAME=core_mongodb_3_0_14

COPY bin/qemu-arm-static /usr/bin

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    curl

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
  rm -rf /tmp/* && \
  rm /usr/bin/qemu-arm-static

EXPOSE 8043/tcp 8088/tcp 27001/udp 27002/tcp 29810/udp 29811/tcp 29812/tcp 29813/tcp

WORKDIR $INSTALL_DIR
CMD java -server -Xms128m -Xmx1024m -XX:MaxHeapFreeRatio=60 -XX:MinHeapFreeRatio=30 -XX:+HeapDumpOnOutOfMemoryError -cp /usr/share/java/commons-daemon.jar:/opt/tplink/EAPController/lib/* -Deap.home=/opt/tplink/EAPController com.tp_link.eap.start.EapLinuxMain
