FROM golang:1.16-alpine AS builder

RUN apk add --no-cache alpine-sdk redis nodejs npm postgresql wget openssh-client

RUN mkdir -m 700 /root/.ssh; \
  touch -m 600 /root/.ssh/known_hosts; \
  ssh-keyscan github.com > /root/.ssh/known_hosts

RUN cp /tmp/storj/id_ed25519 /root/.ssh/id_ed25519
RUN chmod 600 /root/.ssh/id_ed25519

#RUN ssh-add /root/.ssh/id_ed25519

# Skip Host verification for git
RUN echo “StrictHostKeyChecking no “ > /root/.ssh/config

RUN /tmp/storj/build.sh