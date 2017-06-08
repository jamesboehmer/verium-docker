FROM ubuntu:artful

RUN apt-get update -qy && apt-get install -qqy build-essential git libssl-dev libboost-dev libdb-dev libdb++-dev libminiupnpc-dev libqrencode-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev curl automake libcurl4-openssl-dev

RUN git clone https://github.com/VeriumReserve/verium.git && \
	cd verium/src && \
	make -f makefile.unix && \
	strip veriumd && \
	cp veriumd / && \
	cd /  && \
	rm -rf /verium

RUN git clone https://github.com/VeriumReserve/veriumMiner.git
RUN cd veriumMiner && sed -i 's/-flto //g' build.sh && ./build.sh && make install && cd / && rm -rf /veriumMiner

COPY launchveriumd /
