#!/bin/sh

set -e 

cleanup() {
	if [ -d bin/ ]; then
		mv bin/ /artifacts/
	fi

	if [ -d logs/ ]; then
		mv logs/ /artifacts/
	fi
}

trap cleanup EXIT

tar xf /sdk/sdk.tar.zst --strip=1 --no-same-owner -C .

FEEDNAME="${FEEDNAME:-action}"
BUILD_LOG="${BUILD_LOG:-1}"

if [ -z "$NO_DEFAULT_FEEDS" ]; then
	cp feeds.conf.default feeds.conf
fi

echo "src-link $FEEDNAME /feed/" >> feeds.conf

ALL_CUSTOM_FEEDS="$FEEDNAME "
#shellcheck disable=SC2153
for EXTRA_FEED in $EXTRA_FEEDS; do
	echo "$EXTRA_FEED" | tr '|' ' ' >> feeds.conf
	ALL_CUSTOM_FEEDS+="$(echo "$EXTRA_FEED" | cut -d'|' -f2) "
done

./scripts/feeds update -a

make defconfig

for PKG in $PACKAGES; do
	for FEED in $ALL_CUSTOM_FEEDS; do
		./scripts/feeds install -p "$FEED" -f "$PKG"
	done

	make package/$PKG/download BUILD_LOG="$BUILD_LOG" V=s
		
	make package/$PKG/check BUILD_LOG="$BUILD_LOG" V=s
done

for PKG in $PACKAGES; do
	make package/$PKG/compile \
		BUILD_LOG="$BUILD_LOG" \
		V="$V" \
		-j "$(nproc)" \
		"package/$PKG/compile"
done
