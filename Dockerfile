FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes install git curl make g++ dnsmasq patch gyp && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes install nodejs


RUN echo '[Unit]\n\
Description=DNSMASQ\n\
After=network.target \n\
\n\
[Service]\n\
ExecStart=/usr/sbin/dnsmasq -u dnsmasq --strict-order \\\n\
   --pid-file=/run/eth0-dnsmasq.pid \\\n\
   --conf-file= --listen-address 192.168.109.1 \\\n\
   --domain=adviser.com --host-record=digitalfoosball.adviser.com.,192.168.109.1 \\\n\
   --dhcp-range 192.168.109.10,192.168.109.240 --dhcp-lease-max=2048 \\\n\
   --dhcp-no-override --except-interface=lo --interface=eth0 \\\n\
   --dhcp-leasefile=/var/lib/misc/dnsmasq.v202.leases --dhcp-authoritative\n\
ExecReload=/bin/kill -HUP $MAINPID$\n\
KillMode=process\n\
Restart=on-failure\n\
RestartPreventExitStatus=255\n\
Type=notify\n\
\n\
[Install]\n\
WantedBy=multi-user.target\n\
Alias=dnsmasq.service\n' > /etc/systemd/system/dnsmasq.service

RUN echo '[Unit]\n\
Description=DigitalFoosball\n\
After=network.target \n\
\n\
[Service]\n\
PassEnvironment=REDIRECTPORT PORT DOMAIN\n\
WorkingDirectory=/digitalfoosballtable\n\
ExecStart=/usr/bin/node cli.js\n\
Restart=on-failure\n\
RestartPreventExitStatus=255\n\
Type=simple\n\
\n\
[Install]\n\
WantedBy=multi-user.target\n\
Alias=digitalfoosball.service\n' > /etc/systemd/system/digitalfoosball.service

RUN systemctl enable digitalfoosball.service ; \
    systemctl enable dnsmasq.service

WORKDIR /digitalfoosballtable

RUN cd / && \
  git clone https://github.com/mabels/digitalfoosballtable.git && \
  cd /digitalfoosballtable && \
  npm install

CMD ["/bin/systemd"]
