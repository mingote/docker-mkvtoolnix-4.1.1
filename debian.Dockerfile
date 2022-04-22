# FROM ubuntu:lucid as build
FROM debian:7.3 as build

WORKDIR /src

# Copy MKVToolNix 4.1.1 source code
COPY mkvtoolnix-4.1.1.tar.bz2 .

# Copy libebml 1.0.0 source code
COPY libebml-1.0.0.tar.bz2 .

# Copy libmatroska 1.0.0 source code
COPY libmatroska-1.0.0.tar.bz2 .

# RUN sed -i 's/archive/snapshot/' /etc/apt/sources.list && \
RUN echo "deb http://archive.debian.org/debian/ wheezy main non-free contrib\ndeb-src http://archive.debian.org/debian/ wheezy main non-free contrib\ndeb http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib\ndeb-src http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib" > /etc/apt/sources.list && \
	apt-get update -o Acquire::Check-Valid-Until=false && \
	apt-get upgrade --force-yes -y && apt-get install --force-yes -y build-essential autoconf libexpat1-dev libogg-dev libvorbis-dev libflac-dev libmagic-dev zlib1g-dev liblzo2-dev libboost-all-dev gettext && \
	/bin/tar xvjf mkvtoolnix-4.1.1.tar.bz2 && \
	/bin/tar xvjf libebml-1.0.0.tar.bz2 && \
	/bin/tar xvjf libmatroska-1.0.0.tar.bz2 && \
	cd /src/libebml-1.0.0/make/linux && make staticlib && make install_headers install_staticlib && \
	cd /src/libmatroska-1.0.0/make/linux && make staticlib && make install_headers install_staticlib && \
	cd /src/mkvtoolnix-4.1.1 && ./autogen.sh && ./configure && make && make install
	#  && \
	# apt-get purge -y build-essential autoconf libexpat1-dev libogg-dev libvorbis-dev libflac-dev zlib1g-dev libboost-all-dev gettext && apt-get --purge autoremove -y && apt-get autoclean -y && cd && rm -rf /src

# - wxWidgets ( http://www.wxwidgets.org/ ) -- a cross-platform GUI
#   toolkit. You need this if you want to use mmg (the mkvmerge GUI) or
#   mkvinfo's GUI.

# FROM ubuntu:lucid as main
FROM debian:7.3 as main

COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib/lib*.a /usr/local/lib
COPY --from=build /usr/local/share /usr/local/share
COPY --from=build /usr/lib/libmagic.so.1* /usr/lib
COPY --from=build /usr/lib/libboost_regex.so* /usr/lib
COPY --from=build /usr/lib/libboost_filesystem.so* /usr/lib
COPY --from=build /usr/lib/libboost_system.so* /usr/lib
COPY --from=build /usr/lib/libexpat.so* /usr/lib
COPY --from=build /lib/libexpat.so* /lib
COPY --from=build /usr/lib/libicu*.so* /usr/lib
COPY --from=build /usr/lib/libFLAC.so* /usr/lib
COPY --from=build /usr/lib/libogg.so* /usr/lib
COPY --from=build /usr/lib/libvorbis.so* /usr/lib
COPY --from=build /usr/lib/liblzo2.so* /usr/lib
