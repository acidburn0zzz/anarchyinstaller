FROM docker.io/archlinux:latest

# In case we publish the image anywhere
LABEL maintainer="Erazem Kokot <contact at erazem dot eu>"

# Needed to properly set variables inside and outside the container
ENV iscontainer="yes"

RUN pacman -Sy --noconfirm archiso mkinitcpio-archiso reflector
COPY assets /anarchy/assets
COPY src build.sh profiledef.sh /anarchy/
ENTRYPOINT ["/anarchy/build.sh"]
