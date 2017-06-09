FROM ubuntu:artful

RUN apt-get update -qy && apt-get install -qqy build-essential git libssl-dev libboost-dev libdb-dev libdb++-dev libminiupnpc-dev libqrencode-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev curl automake libcurl4-openssl-dev net-tools unzip vim

RUN git clone https://github.com/VeriumReserve/verium.git && \
	cd verium/src && \
	make -f makefile.unix && \
	strip veriumd 

RUN cp verium/src/veriumd /usr/local/bin/ && rm -rf /verium

RUN git clone https://github.com/VeriumReserve/veriumMiner.git
RUN cd veriumMiner && sed -i 's/-flto //g' build.sh && ./build.sh && make install && cd / && rm -rf /veriumMiner

COPY resources/ /

LABEL maintainer="james.boehmer@jamesboehmer.com" \
      com.jamesboehmer.verium.version=0.0.2