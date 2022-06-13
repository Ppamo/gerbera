FROM alpine:3.13 AS gerbera_builder

RUN apk add --no-cache tini gcc g++ pkgconf make \
	util-linux-dev sqlite-dev mariadb-connector-c-dev cmake zlib-dev fmt-dev \
	file-dev libexif-dev curl-dev ffmpeg-dev ffmpegthumbnailer-dev \
	libmatroska-dev libebml-dev taglib-dev pugixml-dev spdlog-dev \
	duktape-dev libupnp-dev git bash

WORKDIR /gerbera_build

COPY . .
RUN mkdir build && \
    cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DWITH_MAGIC=YES \
        -DWITH_MYSQL=YES \
        -DWITH_CURL=YES \
        -DWITH_JS=YES \
        -DWITH_TAGLIB=YES \
        -DWITH_AVCODEC=YES \
        -DWITH_FFMPEGTHUMBNAILER=YES \
        -DWITH_EXIF=YES \
        -DWITH_LASTFM=NO \
        -DWITH_SYSTEMD=NO \
        -DWITH_DEBUG=YES && \
    make -j$(nproc)
