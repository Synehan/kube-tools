FROM docker:19.03.8 as static-docker-source

FROM ubuntu:18.04

ARG KIND_VERSION=v0.7.0
ARG HELM_VERSION=v3.1.0
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz


COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker


RUN apt update && apt install curl jq -y  \
 && curl -L  https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-$(uname)-amd64 >> /usr/local/bin/kind \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl >> /usr/local/bin/kubectl \
 && curl -L https://get.helm.sh/${HELM_FILENAME} | tar xz && mv linux-amd64/helm usr/local/bin/helm && rm -rf linux-amd64 \
 && chmod +x /usr/local/bin/kubectl /usr/local/bin/helm /usr/local/bin/kind \


