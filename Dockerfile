FROM ubuntu:20.04


ARG user=jingchao
ARG passwd=123

ADD sources.list /etc/apt/
RUN DEBIAN_FRONTEND=noninteractive useradd --create-home --password ${passwd} --shell /bin/bash ${user} \
    && adduser ${user} sudo \
    && usermod -aG sudo ${user} \
    && apt update \
    && apt install -y openssh* net-tools lsof telnet vim git gzip zip unzip tar sudo gcc g++ cmake make  python3 systemd \
    && mkdir /var/run/sshd \
    && sed -ri 's/^\s*(PermitRootLogin)/#\1/'                   /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes"                            >> /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(X11Forwarding)/#\1/'                     /etc/ssh/sshd_config \
    && echo "X11Forwarding yes"                              >> /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(X11DisplayOffset)/#\1/'                  /etc/ssh/sshd_config \
    && echo "X11DisplayOffset 10"                           >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(X11UseLocalhost)/#\1/'                   /etc/ssh/sshd_config \
    && echo "X11UseLocalhost no"                            >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(ChallengeResponseAuthentication)/#\1/'   /etc/ssh/sshd_config \
    && echo "ChallengeResponseAuthentication no"            >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(PasswordAuthentication)/#\1/'            /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes"                    >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(UsePAM)/#\1/'                            /etc/ssh/sshd_config \
    && echo "UsePAM no"                                     >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(PermitEmptyPasswords)/#\1/'              /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords yes"                      >>  /etc/ssh/sshd_config \
    && sed -ri 's/^\s*(Compression)/#\1/'                       /etc/ssh/sshd_config \
    && echo "Compression no"                                >>  /etc/ssh/sshd_config 



WORKDIR /home/${user}

EXPOSE 22


USER ${user}

ENTRYPOINT [ "run", "/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config" ]
