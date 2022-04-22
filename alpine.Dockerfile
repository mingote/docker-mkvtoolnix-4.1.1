FROM alpine:latest

WORKDIR /src

# Copy libebml 1.0.0 source code
COPY libebml-1.0.0.tar.bz2 .

# Copy libmatroska 1.0.0 source code
COPY libmatroska-1.0.0.tar.bz2 .

# Copy MKVToolNix 4.1.1 source code
COPY mkvtoolnix-4.1.1.tar.bz2 .

RUN apk update && \
	apk add boost-filesystem flac libdvdread libebml libgcc libmagic libmatroska libogg libstdc++ libvorbis pcre2 expat tini && \
    apk add -t build-deps autoconf boost-dev build-base curl docbook-xsl file-dev flac-dev fmt gtest-dev expat-dev libdvdread-dev libmatroska-dev libogg-dev libvorbis-dev pcre2-dev ruby-json ruby-rake zlib-dev && \
	tar xvjf mkvtoolnix-4.1.1.tar.bz2 && \
	cd /src/mkvtoolnix-4.1.1 && BOOST_LIB_SUFFIX="" ./autogen.sh && ./configure --mandir=/src/mkvtoolnix-man --disable-update-check && \
	rake -j8 && rake install && strip /usr/bin/mkv* && apk del --purge build-deps && rm -rf /var/cache/apk/* && rm -rf /src # buildkit

ENTRYPOINT ["/sbin/tini" "--"]

CMD ["echo" "Please specify a command (i.e., mkvmerge, mkvpropedit, mkvinfo, or mkvextract)."]
