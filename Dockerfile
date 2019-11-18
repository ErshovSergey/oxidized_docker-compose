FROM oxidized/oxidized:latest

RUN mkdir /etc/service/init.oxidized /root/.config/oxidized.default \
  && echo 'ServerAliveInterval 15'> /etc/ssh/ssh_config \
  && echo 'ServerAliveCountMax 0'>> /etc/ssh/ssh_config

COPY init.oxidized /etc/service/init.oxidized/run
COPY config router.db.csv /root/.config/oxidized.default/


