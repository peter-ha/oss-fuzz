#!/bin/bash -eu
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

set -e

# build Qt
./configure -opensource -confirm-license -platform linux-clang -developer-build -debug -no-xcb -no-eglfs -no-widgets -no-compile-examples -nomake examples -nomake tests -qt-pcre -qt-zlib -qt-freetype -qt-harfbuzz -qt-xcb -qt-libpng -qt-libjpeg -qt-sqlite -sanitize address QMAKE_CFLAGS+="$CFLAGS" QMAKE_CXXFLAGS+="$CXXFLAGS" QMAKE_LFLAGS="$CXXFLAGS"
make -j$(nproc) module-qtbase # module-qtdeclarative etc. not built for now

# build fuzzers
cd ../qt-fuzzing/libFuzzer-testcases
../../qt5/qtbase/bin/qmake "LIBS+=-lFuzzingEngine" QMAKE_CFLAGS+="$CFLAGS" QMAKE_CXXFLAGS+="$CXXFLAGS" QMAKE_LFLAGS="$CXXFLAGS"
make -j$(nproc)

fuzzers=$(find . -executable -type f '!' -name run.sh)
for f in $fuzzers; do
    fuzzer=$(basename $f)
    cp $f $OUT/
    #zip -j $OUT/${fuzzer}_seed_corpus.zip fuzz/corpora/${fuzzer}/*
done
