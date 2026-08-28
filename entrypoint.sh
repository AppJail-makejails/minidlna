#!/bin/sh

set -euo pipefail

. /lib.subr

create_user

# VARs
FORCE_SCAN="${FORCE_SCAN:-0}"
FORCE_REBUILD="${FORCE_REBUILD:-0}"
PIDFILE='/var/run/minidlna/minidlna.pid'

if [ -f "${PIDFILE}" ]; then
    rm -f "${PIDFILE}"
fi

for DIR in "$(dirname ${PIDFILE})" "/var/db/minidlna" "/var/log/minidlna"; do
    mkdir -p -- "${DIR}"
    change_owner "${DIR}"
done

MINIDLNA_DB_DIR="${MINIDLNA_DB_DIR:-/var/db/minidlna}"; export MINIDLNA_DB_DIR
MINIDLNA_LOG_DIR="${MINIDLNA_LOG_DIR:-/var/log/minidlna}"; export MINIDLNA_LOG_DIR
MINIDLNA_PORT="${MINIDLNA_PORT:-8200}"; export MINIDLNA_PORT
MINIDLNA_MEDIA_DIR="${MINIDLNA_MEDIA_DIR:-/media}"; export MINIDLNA_MEDIA_DIR
MINIDLNA_ALBUM_ART_NAMES="${MINIDLNA_ALBUM_ART_NAMES:-Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg}"; export MINIDLNA_ALBUM_ART_NAMES
MINIDLNA_INOTIFY="${MINIDLNA_INOTIFY:-yes}"; export MINIDLNA_INOTIFY
MINIDLNA_ENABLE_TIVO="${MINIDLNA_ENABLE_TIVO:-no}"; export MINIDLNA_ENABLE_TIVO
MINIDLNA_TIVO_DISCOVERY="${MINIDLNA_TIVO_DISCOVERY:-bonjour}"; export MINIDLNA_TIVO_DISCOVERY
MINIDLNA_STRICT_DLNA="${MINIDLNA_STRICT_DLNA:-no}"; export MINIDLNA_STRICT_DLNA
MINIDLNA_NOTIFY_INTERVAL="${MINIDLNA_NOTIFY_INTERVAL:-900}"; export MINIDLNA_NOTIFY_INTERVAL
MINIDLNA_SERIAL="${MINIDLNA_SERIAL:-12345678}"; export MINIDLNA_SERIAL
MINIDLNA_MODEL_NUMBER="${MINIDLNA_MODEL_NUMBER:-1}"; export MINIDLNA_MODEL_NUMBER
MINIDLNA_MINISSDPDSOCKET="${MINIDLNA_MINISSDPDSOCKET:-/var/run/minidlna/minissdpd.sock}"; export MINIDLNA_MINISSDPDSOCKET

env | grep -Ee '^MINIDLNA_[A-Z_]+=.+$' | while IFS= read -r env; do
	name=`printf "%s" "${env}" | cut -d= -f1 | tr '[:upper:]' '[:lower:]'`
	name=`printf "%s" "${name}" | sed -Ee 's/^minidlna_(.+)/\1/'`
	value=`printf "%s" "${env}" | cut -d= -f2-`

	printf "%s=%s\n" "${name}" "${value}"
done > "/usr/local/etc/minidlna.conf"

if [ "$FORCE_SCAN" != 0 ]; then
  set -- -r "$@"
fi
if [ "$FORCE_REBUILD" != 0 ]; then
  set -- -R "$@"
fi

exec su-exec noroot minidlnad -d -P "${PIDFILE}" "$@"
