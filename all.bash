#!/bin/sh
set -eux

sh genversion.sh fuse/version.gen.go

for target in "clean" "install" ; do
  for d in raw fuse fuse/pathfs fuse/test zipfs unionfs \
    example/hello example/loopback example/zipfs \
    example/multizip example/unionfs example/memfs \
    example/autounionfs ; \
  do
    go ${target} go-fuse/${d}
  done
done

for d in fuse zipfs unionfs
do
  (cd $d && go test go-fuse/$d && go test -race go-fuse/$d)
done

make -C benchmark
for d in benchmark
do
  go test go-fuse/benchmark -test.bench '.*' -test.cpu 1,2
done
