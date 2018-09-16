ARG LTS_VERSION=12.7

FROM fpco/stack-build:lts-${LTS_VERSION} as build

# Need to respecify lts_version as args pre-FROM are cleared.
ARG LTS_VERSION=12.7
ARG GHC_VERSION=8.4.3

RUN mkdir /opt/build
COPY . /opt/build
RUN cd /opt/build && stack build --system-ghc

FROM alpine:latest

# RUN mkdir -p /opt/resource
WORKDIR /opt/resource
# also install bash b/c fly intercept looks for /bin/bash instead of /bin/sh
RUN apk --no-cache add ca-certificates bash
COPY --from=build /opt/build/.stack-work/install/x86_64-linux/lts-${LTS_VERSION}/${GHC_VERSION}/bin .

