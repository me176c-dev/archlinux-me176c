#!/usr/bin/env bash
set -e

sudo rm -rf releng
cp -r /usr/share/archiso/configs/releng releng
cd releng

git init
git add -A
git commit -m "Initial Commit"
git apply ../relang.patch
