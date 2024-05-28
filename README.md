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
    -o virtualnet=":<random> default" \
    -o expose=8200 \
    -o expose="1900 proto:udp" \
    -o nat \
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
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  dlna:
    name: minidlna
    makejail: gh+AppJail-makejails/minidlna
    options:
      - expose: '8200'
      - expose: '1900 proto:udp'
    environment:
      - MINIDLNA_MEDIA_DIR: '/media'
      - MINIDLNA_INOTIFY: 'yes'
      - MINIDLNA_FRIENDLY_NAME: 'Home Media Server'
      - MINIDLNA_ENABLE_TIVO: 'yes'
      - MINIDLNA_ALBUM_ART_NAMES: 'Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg'
      - MINIDLNA_INOTIFY: 'yes'
      - MINIDLNA_ENABLE_TIVO: 'no'
      - MINIDLNA_TIVO_DISCOVERY: 'bonjour'
      - MINIDLNA_STRICT_DLNA: 'no'
      - MINIDLNA_NOTIFY_INTERVAL: '900'
      - MINIDLNA_SERIAL: '12345678'
      - MINIDLNA_MODEL_NUMBER: '1'
    volumes:
      - media: /media

volumes:
  media:
    device: /media
    type: nullfs
    options: ro
```

**.env**:

```
DIRECTOR_PROJECT=minidlna
```

### Arguments

* `minidlna_tag` (default: `13.3`): See [#tags](#tags).

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `13.3` | `amd64` | `13.3-RELEASE` | `thin` |
| `14.0` | `amd64` | `14.0-RELEASE` | `thin` |
