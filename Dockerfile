#Base  image
FROM alpine:latest

# upgrade base system and install samba and supervisord
RUN apk --no-cache upgrade && apk --no-cache add samba samba-common-tools supervisor aws-cli rclone

# create a dir for the config and the share
RUN mkdir -p /smbdrive /root/.aws /root/.config/rclone

# copy config files from project folder to get a default config going for samba and supervisord
COPY smb.conf /root/.config/
COPY supervisord.conf /root/.config/
COPY rclone.conf /root/.config/rclone/
COPY rclone.sh /etc/periodic/hourly/
RUN chmod a+x /etc/periodic/hourly/rclone.sh

# add a non-root user and group called "rio" with no password, no home dir, no shell, and gid/uid set to 1000
RUN addgroup -g 1000 rio && adduser -D -H -G rio -s /bin/false -u 1000 rio

# create a samba user matching our user from above with a very simple password ("letsdance")
RUN echo -e "letsdance\nletsdance" | smbpasswd -a -s -c /root/.config/smb.conf rio

# volume mappings
VOLUME /smbdrive
VOLUME /.aws

# exposes samba's default ports (135 for End Point Mapper [DCE/RPC Locator Service],
# 137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 135/tcp 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["supervisord", "-c", "/root/.config/supervisord.conf"]
