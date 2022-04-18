FROM ubuntu:lucid

RUN sed -i 's/archive/old-releases/' /etc/apt/sources.list
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y build-essential autoconf libexpat1-dev libogg-dev libvorbis-dev libflac-dev zlib1g-dev libboost-all-dev gettext

ENV SRC=/src
WORKDIR ${SRC}

# Copy MKVToolNix 4.1.1 source code
ENV FILE=mkvtoolnix-4.1.1.tar.bz2
COPY ${FILE} .
RUN /bin/tar xvjf ${FILE} && rm ${FILE}

# Copy libebml 1.0.0 source code
ENV FILE=libebml-1.0.0.tar.bz2
COPY ${FILE} .
RUN /bin/tar xvjf ${FILE} && rm ${FILE}

# Copy libmatroska 1.0.0 source code
ENV FILE=libmatroska-1.0.0.tar.bz2
COPY ${FILE} .
RUN /bin/tar xvjf ${FILE} && rm ${FILE}

# Build libebml
RUN cd libebml-1.0.0/make/linux && make staticlib && make install_headers install_staticlib

# Build libmatroska
RUN cd libmatroska-1.0.0/make/linux && make staticlib && make install_headers install_staticlib

# 2.4. Building MKVtoolNix
RUN cd mkvtoolnix-4.1.1 && ./autogen.sh && ./configure && make && make install

# - wxWidgets ( http://www.wxwidgets.org/ ) -- a cross-platform GUI
#   toolkit. You need this if you want to use mmg (the mkvmerge GUI) or
#   mkvinfo's GUI.
# - libFLAC ( http://downloads.xiph.org/releases/flac/ ) for FLAC
#   support (Free Lossless Audio Codec)
# - lzo ( http://www.oberhumer.com/opensource/lzo/ ) and bzip2 (
#   http://www.bzip.org/ ) are compression libraries. These are the
#   least important libraries as almost no application supports Matroska
#   content that is compressed with either of these libs. The
#   aforementioned zlib is what every program supports.
# - libMagic from the "file" package ( http://www.darwinsys.com/file/ )
#   for automatic content type detection
