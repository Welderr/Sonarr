FROM ubuntu:focal

LABEL maintainer="Jeroen Vermeylen <jeroen@vermeylen.org>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg2 gnupg ca-certificates curl wget && apt-get clean

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt-get clean

RUN wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-13_all.deb && \
    dpkg -i repo-mediaarea_1.0-13_all.deb && \
    apt-get update && \
    apt-get clean

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 2009837CBFFD68F45BC180471F4F90DE2A9B4BF8 && \
    echo "deb https://apt.sonarr.tv/ubuntu focal main" | tee /etc/apt/sources.list.d/sonarr.list && \
    apt update && \
    apt install -y sonarr && \
    apt-get clean

RUN mkdir /series && \
    mkdir /downloads && \
    mkdir /config
VOLUME /config /series /downloads
EXPOSE 8989

HEALTHCHECK CMD wget -q localhost:8989 -O /dev/null

CMD [ "mono", "--debug", "/usr/lib/sonarr/bin/Sonarr.exe", "--data=/config" ]

