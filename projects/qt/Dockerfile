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

FROM ossfuzz/base-libfuzzer
MAINTAINER google@peterh.33mail.com

# list Qt dependencies first, because they rarely change:
RUN apt-get build-dep --yes qtbase-opensource-src
RUN apt-get install --yes libxcb-xinerama0-dev

# fuzzing test cases live on github for now:
RUN git clone --depth 1 https://github.com/peter-ha/qt-fuzzing.git

# clone Qt itself:
RUN git clone --depth 1 https://code.qt.io/qt/qt5.git
WORKDIR qt5
# the script below will call "git submodule init" and "git submodule update":
RUN ./init-repository --force --module-subset=qtbase
#RUN ./init-repository --force --module-subset=qtbase,qtdeclarative
COPY build.sh $SRC/
