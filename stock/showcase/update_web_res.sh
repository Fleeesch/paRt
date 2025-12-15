#!/usr/bin/env bash

# sync folder
sync_pair() {
  src="$1"
  dst="$2"

  mkdir -p "$src" "$dst"
  cp -a "$src/." "$dst/"
}

WEB_PATH="c:/root/int/dev/github/fleeesch.github.io/part"

# folder pairs
sync_pair "./out/bb" "$WEB_PATH/bb"
sync_pair "./out/sshot" "$WEB_PATH/res/gallery/sshot"
sync_pair "./out/web" "$WEB_PATH/res/gallery/thumb"

