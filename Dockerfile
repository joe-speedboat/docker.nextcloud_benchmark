FROM alpine:3.13
LABEL maintainer="Chris Ruettimann <chris@bitbull.ch>"

# keep this from underlying container
ARG VERSION=1.08
ARG APK_FLAGS_COMMON=""
ARG APK_FLAGS_PERSISTENT="${APK_FLAGS_COMMON} --clean-protected --no-cache"
ARG APK_FLAGS_DEV="${APK_FLAGS_COMMON} --no-cache"

STOPSIGNAL SIGTERM

USER root
WORKDIR /tmp

# add needed software
RUN apk add ${APK_FLAGS_DEV} bash bind-tools curl iftop openssl bc jq wget tini coreutils

# install the benchmark script
ADD https://raw.githubusercontent.com/joe-speedboat/shell.scripts/master/nc_benchmark.sh /usr/bin/nc_benchmark.sh 

COPY ["nc_bench_loop.sh", "/usr/bin/"]
RUN chmod 755 /usr/bin/nc_benchmark.sh /usr/bin/nc_bench_loop.sh

# start the benchmark in loop
ENTRYPOINT ["/sbin/tini", "--"]

USER 1997

CMD ["/usr/bin/nc_bench_loop.sh", "/tmp/nc_benchmark.conf"]
