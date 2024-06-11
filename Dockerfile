#Base  image
FROM ghcr.io/jitesoft/alpine

# Install samba packages
RUN apk add samba

# Code file to execute when the docker container starts up (`entrypoint.sh`)
CMD ["rc-service", "samba", "start"]