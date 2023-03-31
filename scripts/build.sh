#!/usr/bin/env bash

set -ex

# x64
GOOS="windows" GOARCH="amd64" go build -o $PWD/fontloader.exe github.com/dbathgate/windowsfontloader