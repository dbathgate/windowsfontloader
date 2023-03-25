#!/usr/bin/env bash

set -ex

mkdir -p $PWD/fontloader-rel
# x64
GOOS="windows" GOARCH="amd64" go build -o $PWD/fontloader-rel/fontloader.exe github.com/dbathgate/windowsfontloader