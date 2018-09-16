ARG LTS_VERSION=12.7

FROM fpco/stack-build:lts-${LTS_VERSION} as build
# Need to respecify lts_version as args pre-FROM are cleared and we're in another image.
ARG LTS_VERSION=12.7
ARG GHC_VERSION=8.4.3

RUN mkdir /opt/build
WORKDIR /opt/build
COPY . .
RUN stack build --system-ghc
RUN mv .stack-work/install/x86_64-linux/lts-${LTS_VERSION}/${GHC_VERSION}/bin /opt/build/output

FROM debian:9

WORKDIR /opt/resource
RUN apt-get update -y && \
    apt-get install -y \
            ca-certificates \
            libgmp-dev \
            build-essential && \
    rm -r /var/lib/apt/lists/*
COPY --from=build /opt/build/output .
