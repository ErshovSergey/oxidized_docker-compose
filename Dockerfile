FROM oxidized/oxidized:latest

RUN mkdir -p /etc/service/init.oxidized /root/.config/oxidized.default /root/.config/oxidized.default/devices

COPY init.oxidized /etc/service/init.oxidized/run
COPY config router.db.csv htpasswd /root/.config/oxidized.default/
COPY ssh_config.dlink /etc/ssh/ssh_config

COPY new-devices/*.rb /root/.config/oxidized.default/devices/
