FROM alpine:3.16.3@sha256:3d426b0bfc361d6e8303f51459f17782b219dece42a1c7fe463b6014b189c86d

RUN apk update
RUN apk add bash curl zip openssh

WORKDIR /tmp

# Packer
RUN curl -o packer.zip -L https://releases.hashicorp.com/packer/1.8.4/packer_1.8.4_linux_amd64.zip
RUN unzip packer.zip
RUN mv ./packer /usr/local/bin/packer
RUN rm packer.zip

# Entrypoint
WORKDIR /mnt
ENTRYPOINT [ "/bin/bash" ]