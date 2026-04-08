# jetson-util

A Docker container with common CLI tools for host maintenance and file
management, as well as some other general diagnostics. Intended to avoid
polluting host with extra packages.

Host: Jetson Orin NX
OS: Ubuntu 22.04 (Jammy)
JP: 6.x

## Quick Start

```bash
# Build
./build_util.sh

# Run
./run_util.sh
```

## Included Tools

| Category                | Tools                                                              |
|-------------------------|--------------------------------------------------------------------|
| **Editors**             | vim, nano                                                          |
| **Shell / Terminal**    | tmux, screen, bash-completion                                      |
| **Archive / Compress**  | 7z, zip/unzip, tar, gzip, bzip2, xz, zstd, lz4, pigz, pbzip2       |
| **File Management**     | rsync, ncdu, fd, ripgrep, tree, rename                             |
| **Transfer**            | curl, wget, scp (openssh-client), sshfs                            |
| **Networking**          | nmcli, ip, ping, traceroute, dig, nmap, iperf3, tcpdump, socat     |
| **Monitoring**          | htop, iotop, sysstat (sar/mpstat/iostat), lsof, strace             |
| **Disk / Filesystem**   | parted, fdisk, e2fsprogs, ntfs-3g, exfat, smartctl, hdparm         |
| **Misc**                | git, jq, bc, file, xxd                                             |

## Host Filesystem Access

Container run mounts entire host root at `/host` (read-write); can reach
any file on Jetson:

```bash
# Inside container
ls /host/etc/nv_tegra_release  # Jetson info
ncdu /host/home                # info on disk space
7z a /host/tmp/dataset.7z /host/home/user/data/  # archive a dataset
```

`/home`, `/media`, `/mnt`, and `/tmp` are also mounted at their expected
paths for convenience.

## Archiving Large Datasets

`p7zip-full` is included for high-ratio compression. For multi-threaded
speed on Orin NX (8-core), consider `pigz` (gzip) and `pbzip2` (bzip2):

```bash
# 7zip with LZMA2, 8 threads, split into 4 GB volumes
7z a -t7z -m0=lzma2 -mx=7 -mmt=8 -v4g /host/tmp/archive.7z /host/data/

# Fast tarball with parallel gzip
tar cf - /host/data/ | pigz -p 8 > /host/tmp/archive.tar.gz

# Zstandard — excellent speed/ratio tradeoff
tar cf - /host/data/ | zstd -T8 -o /host/tmp/archive.tar.zst
```

## Networking

The container runs with `--network host` and `--privileged`, so `nmcli`,
`tcpdump`, `iperf3`, etc. operate directly on the host's interfaces:

```bash
nmcli device status
nmcli connection show
tcpdump -i eth0 -c 50
```

## Notes

- **`--privileged` + `--pid host`**: Required for `iotop`, `strace`,
  `smartctl`, `hdparm`, `tcpdump`, and `nmcli` to function correctly.
  Remove these flags if only basic file/archive tools are needed.
- **Container is ephemeral**: Stopping the container loses any packages
  installed at runtime. Add them to Dockerfile instead.
- **No GPU passthrough**: This container is for maintenance, not compute.
  No ROS 2, SLAM, or other related pipeline available.