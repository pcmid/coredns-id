#!/bin/bash

set -x

update_repo() {
    branch=$1
    [ ! -z $branch ] && branch_arg="--branch $branch"
    [ ! -d coredns ] && git clone https://github.com/coredns/coredns --depth=1 $branch_arg || 
        pushd coredns && git reset HEAD --hard && git fetch origin $branch --depth 1 && git checkout FETCH_HEAD && popd
}


update_repo $1

pushd coredns

sed -i plugin.cfg \
    -e 's/\(forward:forward\)$/blocklist:github.com\/relekang\/coredns-blocklist\n\1/g' \
    -e 's/\(forward:forward\)$/dispatch:github.com\/pcmid\/dispatch\n\1/g'

make gen
make coredns

popd

