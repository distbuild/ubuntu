FROM ubuntu:22.04

USER root
ARG GID=1000
ARG UID=1000
ARG LANG_EN="en_US.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt install -y build-essential curl file git locales lsof m4 make net-tools && \
    apt install -y patch python3 python3-pip software-properties-common && \
    apt install -y sudo unzip upx vim wget zip
RUN apt autoremove --purge -y > /dev/null && \
    apt autoclean -y > /dev/null && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/log/* && \
    rm -rf /tmp/*
RUN echo "LC_ALL=$LANG_EN" >> /etc/environment && \
    echo "LANG=$LANG_EN" > /etc/locale.conf && \
    echo "$LANG_EN UTF-8" >> /etc/locale.gen && \
    echo "StrictHostKeyChecking no" | tee --append /etc/ssh/ssh_config && \
    echo "ulimit -n 4096" | tee --append /etc/profile && \
    echo "ulimit -s 102400" | tee --append /etc/profile && \
    echo "aosp ALL=(ALL) NOPASSWD: ALL" | tee --append /etc/sudoers && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    groupadd -g $GID aosp && \
    useradd -d /home/aosp -ms /bin/bash -g aosp -u $UID aosp
RUN locale-gen $LANG_EN && \
    update-locale LC_ALL=$LANG_EN LANG=$LANG_EN
ENV LANG=$LANG_EN
ENV LC_ALL=$LANG_EN
ENV SHELL="/bin/bash"

USER aosp
WORKDIR /home/aosp
