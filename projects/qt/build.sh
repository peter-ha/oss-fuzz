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

# build Qt
./configure -opensource -confirm-license -platform linux-clang -prefix $WORK/qt-install -static -debug -nomake examples -nomake tests -no-widgets -sanitize address QMAKE_CFLAGS+="$CFLAGS" QMAKE_CXXFLAGS+="$CXXFLAGS" QMAKE_LFLAGS+="$CXXFLAGS"

# -k because we will get errors in qlalr (which we don't need)
make -k -j$(nproc) module-qtbase || true # module-qtdeclarative etc. not built for now
cd qtbase
make install

# build fuzzers
cd ../../qt-fuzzing/libFuzzer-testcases
$WORK/qt-install/bin/qmake "LIBS+=-lFuzzingEngine" QMAKE_CFLAGS+="$CFLAGS" QMAKE_CXXFLAGS+="$CXXFLAGS" QMAKE_LFLAGS="$CXXFLAGS"
make -j$(nproc)

fuzzers=$(find . -executable -type f '!' -name run.sh)
for f in $fuzzers; do
    fuzzer=$(basename $f)
    cp $f $OUT/
    #zip -j $OUT/${fuzzer}_seed_corpus.zip fuzz/corpora/${fuzzer}/*
done
