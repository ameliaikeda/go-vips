FROM ubuntu:18.04 AS build

ENV LIBVIPS_VERSION="8.7.4" \
    LIBVIPS_DOWNLOAD_URL="https://github.com/libvips/libvips/releases/download/v8.7.4/vips-8.7.4.tar.gz" \
    LIBVIPS_DOWNLOAD_SHA256="ce7518a8f31b1d29a09b3d7c88e9852a5a2dcb3ee1501524ab477e433383f205" \
    GOLANG_VERSION="1.11.5" \
    GOLANG_DOWNLOAD_URL="https://golang.org/dl/go1.11.5.linux-amd64.tar.gz" \
    GOLANG_DOWNLOAD_SHA256="ff54aafedff961eb94792487e827515da683d61a5f9482f668008832631e5d25" \
    DEBIAN_FRONTEND="noninteractive" \
    PATH="/usr/local/go/bin:$PATH"

# Install required libraries
RUN \
    apt-get update && \
    apt-get install -y \
    ca-certificates \
    automake build-essential curl gcc git libc6-dev make \
    gobject-introspection gtk-doc-tools libglib2.0-dev libjpeg-turbo8-dev libpng-dev \
    libwebp-dev libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev \
    swig libmagickwand-dev libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev \
    libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev libimagequant-dev && \
    \
    # update ca-certificates
    update-ca-certificates

# install libvips
RUN \
    cd /tmp && \
    \
    # verify the download before unpacking
    curl -fsSL "$LIBVIPS_DOWNLOAD_URL" -o libvips.tar.gz && \
    echo "$LIBVIPS_DOWNLOAD_SHA256 libvips.tar.gz" | sha256sum -c - && \
    \
    # unpack and build
    tar zvxf libvips.tar.gz && \
    cd vips-$LIBVIPS_VERSION && \
    ./configure --enable-debug=no --without-python $1 && \
    make && \
    make install && \
    ldconfig

# install golang
RUN \
    # download and verify golang
    curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz  && \
    echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - && \
    tar -C /usr/local -xzf golang.tar.gz && \
    rm golang.tar.gz

