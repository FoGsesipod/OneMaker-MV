FROM ubuntu:14.10

RUN sed -i 's/archive/old-releases/' /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get install libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev libxi-dev \
    libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev \
    libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev \
    libxcb-randr0-dev libxcb-render-util0-dev build-essential unzip libglib2.0-dev -y

COPY qt.tar.xz /qt.tar.xz

RUN tar -xf /qt.tar.xz

WORKDIR /qt-everywhere-opensource-src-5.5.1

RUN ./configure -opensource -confirm-license -release -optimized-qmake -nomake examples -qt-xcb -qt-zlib -qt-libpng -glib -v

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY qresource_5.5.1.cpp /qt-everywhere-opensource-src-5.5.1/qtbase/src/corelib/io/qresource.cpp

CMD ["/docker-entrypoint.sh"]