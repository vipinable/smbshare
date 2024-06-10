#Base  image
FROM hub.docker.com/debin:stable

# Install samba packages
RUN apt update && apt install -y samba


# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]