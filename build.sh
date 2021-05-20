#!/bin/sh -e
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
FROM="alpine:3.13"
VERSION=1.09
IMAGE=nextcloud_benchmark
TO="christian773/$IMAGE"

cd $(dirname $0) 
docker system prune -a -f

sed -i "s@^FROM .*@FROM $FROM@" Dockerfile
sed -i "s@^ARG VERSION=.*@ARG VERSION=$VERSION@" Dockerfile

docker build -t $IMAGE:$VERSION .

for V in $VERSION latest
do
   docker tag $IMAGE:$VERSION $TO:$V
   docker push $TO:$V
done

