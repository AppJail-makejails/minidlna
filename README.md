# MiniDLNA

ReadyMedia (previously MiniDLNA) is server software with the aim of being fully compliant with DLNA/UPnP clients. The MiniDLNA daemon serves media files (music, pictures, and video) to clients on a network.

minidlna.sourceforge.net

## How to use this Makejail

To configure your MiniDLNA you must keep the following in mind: each parameter has a value, it must be prefixed with `MINIDLNA_` and the rest must be in uppercase and must only contain letters and underscores.

```console
$ mkdir -p db log
$ appjail oci run -Pd \
    -o overwrite=force \
    -o alias \
    -o ip4_inherit \
    -o ip6_inherit \
    -e MINIDLNA_NOTIFY_INTERVAL="60" \
    -e MINIDLNA_MEDIA_DIR="V,/media/Videos" \
    -o fstab="/path/to/your/media /media" \
    -o fstab="$PWD/db /var/db/minidlna" \
    -o fstab="$PWD/log /var/log/minidlna" \
    ghcr.io/appjail-makejails/minidlna minidlna
```

### Arguments (stage: build)

* `minidlna_from` (default: `ghcr.io/appjail-makejails/minidlna`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `minidlna_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.
* `UMASK` (default: `0022`): Override default umask setting.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
