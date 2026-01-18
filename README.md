# MiniDLNA

ReadyMedia (previously MiniDLNA) is server software with the aim of being fully compliant with DLNA/UPnP clients. The MiniDLNA daemon serves media files (music, pictures, and video) to clients on a network.

sourceforge.net/projects/minidlna

## How to use this Makejail

### Standalone

To configure your MiniDLNA you must keep the following in mind: each parameter has a value, it must be prefixed with `MINIDLNA_` and the rest must be in uppercase and must only contain letters and underscores.

```sh
appjail makejail \
    -j minidlna \
    -f gh+AppJail-makejails/minidlna \
    -o bridge="iface:jext minidlna" \
    -o dhcp="sb_minidlna" \
    -o macaddr="sb_minidlna:58-9c-fc-00-00-10" \
    -o mount_devfs \
    -o device='include $devfsrules_hide_all' \
    -o device='include $devfsrules_unhide_basic' \
    -o device='include $devfsrules_unhide_login' \
    -o device="path 'bpf*' unhide" \
    -o fstab="/tmp/media /media nullfs ro" \
    -V MINIDLNA_MEDIA_DIR=/media \
    -V MINIDLNA_INOTIFY=yes \
    -V MINIDLNA_FRIENDLY_NAME="Home Media Server" \
    -V MINIDLNA_ENABLE_TIVO=yes \
    -V MINIDLNA_ALBUM_ART_NAMES="Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg" \
    -V MINIDLNA_INOTIFY=yes \
    -V MINIDLNA_ENABLE_TIVO=no \
    -V MINIDLNA_TIVO_DISCOVERY=bonjour \
    -V MINIDLNA_STRICT_DLNA=no \
    -V MINIDLNA_NOTIFY_INTERVAL=900 \
    -V MINIDLNA_SERIAL=12345678 \
    -V MINIDLNA_MODEL_NUMBER=1
```

### Deploy using appjail-director

**appjail-director.yml**:

```yaml
services:
  dlna:
    name: minidlna
    makejail: gh+AppJail-makejails/minidlna
    options:
      - bridge: !ENV 'iface:${EXT_IF} ${INT_IF}'
      - dhcp: !ENV 'sb_${INT_IF}'
      - macaddr: !ENV 'sb_${INT_IF}:${MACADDR}'
      - mount_devfs:
      - device: "include $devfsrules_hide_all"
      - device: "include $devfsrules_unhide_basic"
      - device: "include $devfsrules_unhide_login"
      - device: "path 'bpf*' unhide"
    volumes:
      - movies: /media
    environment:
      - MINIDLNA_MEDIA_DIR: '/media'
      - MINIDLNA_INOTIFY: 'yes'
      - MINIDLNA_FRIENDLY_NAME: 'Home Media Server'
      - MINIDLNA_STRICT_DLNA: no
      - MINIDLNA_ENABLE_TIVO: 'yes'
      - MINIDLNA_ALBUM_ART_NAMES: 'Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg'
      - MINIDLNA_INOTIFY: 'yes'
      - MINIDLNA_ENABLE_TIVO: 'no'
      - MINIDLNA_TIVO_DISCOVERY: 'bonjour'
      - MINIDLNA_STRICT_DLNA: 'no'
      - MINIDLNA_NOTIFY_INTERVAL: '900'
      - MINIDLNA_SERIAL: '12345678'
      - MINIDLNA_MODEL_NUMBER: '1'
    arguments:
      - minidlna_tag: 15

volumes:
  media:
    device: /media
    type: nullfs
    options: ro
```

**.env**:

```
DIRECTOR_PROJECT=minidlna
EXT_IF=jext
INT_IF=minidlna
MACADDR=58-9c-fc-00-00-10
```

### Arguments

* `minidlna_tag` (default: `14.3`): See [#tags](#tags).
* `minidlna_ajspec` (default: `gh+AppJail-makejails/minidlna`): Entry point where the `appjail-ajspec(5)` file is located.

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `14.3` | `amd64` | `14.3-RELEASE` | `thin` |
| `15` | `amd64` | `15` | `thin` |
