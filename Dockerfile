FROM docker:19.03.8 as static-docker-source

FROM ubuntu:18.04

ARG KIND_VERSION=v0.7.0
ARG HELM_VERSION=v3.1.0

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
RUN apt update && apt install curl jq -y && \
    curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-$(uname)-amd64 && \
    mv ./kind /usr/local/bin/kind && \
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/helm /usr/local/bin/kind /usr/local/bin/kubectl && \
    adduser kube --home /home/kube --disabled-password && \
    rm -rf linux-amd64 *.tar.gz

USER kube

WORKDIR /home/kube
