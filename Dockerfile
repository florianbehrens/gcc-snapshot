FROM ubuntu:23.04

COPY ./build.sh .
RUN chmod 755 build.sh && ./build.sh && rm build.sh

WORKDIR /
CMD /bin/bash
