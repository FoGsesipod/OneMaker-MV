#!/bin/bash
echo "Building..."
cd /qt-everywhere-opensource-src-5.5.1
make module-qtbase -j$(nproc)

cp /qt-everywhere-opensource-src-5.5.1/qtbase/lib/libQt5Core.so.5 /output/libQt5Core.so.5
echo "I've output the library. Enjoy."