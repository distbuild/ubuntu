FROM ubuntu:20.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Set Bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash
ENV SHELL="/bin/bash"

# Install tools
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt update -y && \
    apt install -y build-essential curl ethtool file git locales libgconf-2-4 libsecret-1-dev \
        lsof m4 make net-tools openjdk-17-jdk patch pkg-config python3 python3-pip software-properties-common \
        sudo unzip upx vim wget zip

# Install Bazel
RUN apt install -y apt-transport-https curl gnupg && \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /usr/share/keyrings && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    apt update -y && \
    apt install -y bazel-6.4.0 && \
    apt install -y bazel-6.3.2

# Clean files
RUN apt autoremove --purge -y > /dev/null && \
    apt autoclean -y > /dev/null && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/log/* && \
    rm -rf /tmp/*

# Install Go
RUN mkdir -p /opt/go && \
    curl -LO https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
    tar zxvf *.tar.gz -C /opt/go && \
    rm *.tar.gz
ENV GOPATH=/opt/go
ENV PATH=/opt/go/bin:$PATH

# Install depot_tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools --depth=1
ENV PATH=$PWD/depot_tools:$PATH
