FROM arm32v7/openjdk:8-jre

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
RUN wget https://static.tp-link.com/2018/201811/20181108/Omada_Controller_v3.0.5_linux_x64.tar.gz.zip && \
  unzip Omada_Controller_v3.0.5_linux_x64.tar.gz.zip && \
  tar -xvf Omada_Controller_v3.0.5_linux_x64.tar.gz -C ./omada

WORKDIR /opt/mongo
RUN wget https://andyfelong.com/downloads/core_mongodb_3_0_14.tar.gz && \
  tar -xvf core_mongodb_3_0_14.tar.gz /tmp/omada/bin
