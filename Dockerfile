FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes install git curl make g++ && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get --yes install nodejs

WORKDIR /digitalfoosballtable

RUN cd / && git clone https://github.com/mabels/digitalfoosballtable.git

RUN npm install yarn -g && yarn install

