FROM debian:buster-slim

LABEL maintainer="Justin Hauer"
#Set Env Vars
ENV HUGO_VERSION=0.69.2
ENV HUGO_ARCH=64bit
ENV PLUGIN_HUGO_ARCH=$HUGO_ARCH
ENV PLUGIN_HUGO_SHIPPED_VERSION=$HUGO_VERSION
# Install packages, Hugo, AWS CLI
RUN apt-get update && apt-get install git wget curl unzip -y 
RUN wget -O- https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz | tar xz -C /bin
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN apt-get remove curl wget unzip libcurl4 -y \
        && rm -Rf awscliv2.zip \
        && rm -Rf /var/cache/apt \
        && rm -Rf /var/lib/apt/lists/* \
        && rm -Rf /var/log/*
ENTRYPOINT ["/bin/hugo"]