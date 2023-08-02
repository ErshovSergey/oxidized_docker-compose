FROM oxidized/oxidized:0.29.1

RUN mkdir -p /etc/service/init.oxidized /home/oxidized/.config/oxidized.default /home/oxidized/.config/oxidized.default/devices

COPY init.oxidized /etc/service/init.oxidized/run
COPY config router.db.csv htpasswd /home/oxidized/.config/oxidized.default/
COPY ssh_config.dlink /etc/ssh/ssh_config

COPY new-devices/*.rb /home/oxidized/.config/oxidized.default/devices/

