FROM docker.io/golang:1.20.3 as build_env
ENV GOPATH=/go
ENV GOCACHE=/go/cache
ARG VERSION=master
WORKDIR /build

COPY ./ ./

RUN --mount=type=cache,target=/go \
    ./build.sh $VERSION 

FROM docker.io/debian:stable-slim AS run_env
WORKDIR /

RUN apt-get update \
    && apt-get install -y ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ 

# copy binary
COPY --from=build_env /build/coredns/coredns /coredns

# run program
ENTRYPOINT ["/coredns"]

