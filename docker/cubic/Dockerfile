FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    x11-apps \
    python3-gi \
    gir1.2-gtk-3.0 \
    gir1.2-vte-2.91 \
    sudo \
    dbus-x11 \
    && add-apt-repository -y ppa:cubic-wizard/release \
    && apt-get update && apt-get install -y cubic \
    && apt-get clean

ARG USERNAME=cubic
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
#RUN mkdir /home/${USERNAME}/cubic
WORKDIR /home/${USERNAME}
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cubic"]
