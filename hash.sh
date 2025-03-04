#!/usr/bin/env bash
cd $1
TEST=`git submodule | md5sum`
echo $TEST