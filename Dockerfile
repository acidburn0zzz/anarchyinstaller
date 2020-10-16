FROM docker.io/archlinux:latest

LABEL maintainer="Erazem Kokot <contact at erazem dot eu>"
ENV iscontainer="yes"

RUN pacman -Sy --noconfirm archiso mkinitcpio-archiso reflector
COPY src anarchy-packages.x86_64 build.sh profiledef.sh /anarchy
ENTRYPOINT ["/anarchy/build.sh"]
