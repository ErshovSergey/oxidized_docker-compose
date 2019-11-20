FROM oxidized/oxidized:latest

RUN mkdir /etc/service/init.oxidized /root/.config/oxidized.default \
  && echo 'ServerAliveInterval 15'> /etc/ssh/ssh_config \
  && echo 'ServerAliveCountMax 0'>> /etc/ssh/ssh_config

COPY init.oxidized /etc/service/init.oxidized/run
COPY config router.db.csv /root/.config/oxidized.default/


ENV TZ=US/Alaska

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

